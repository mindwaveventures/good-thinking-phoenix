defmodule App.Resources do
  @moduledoc """
  # Functions for querying CMS Database for resources
  """
  use App.Web, :controller

  alias App.Likes

  @bucket_name Application.get_env :app, :bucket_name

  def sort_priority(list),
    do: Enum.sort list, &(&1[:priority] <= &2[:priority])

  @doc """
    iex> get_content(:alphatext) =~ "Take part in our ALPHA"
    true
    iex> get_content([:body, :footer]).body =~ "London Minds"
    true
    iex> get_content([:body, :footer]).footer =~ ""
    true
    iex> get_content(:alphatext, "feedback") =~ ""
    true
  """
  def get_content(content), do: get_content(content, "home")
  def get_content(content, view) when is_binary(view) do
    tuple = case view do
      "home" -> {"/home/", "home_homepage"}
      _ -> {"/home/#{view}/", "#{view}_#{view}page"}
    end
    get_content(content, tuple)
  end
  def get_content(content, {url_path, table_name})
    when is_list(content) or is_atom(content)
    do
    query = from page in "wagtailcore_page",
              where: page.url_path == ^url_path,
              join: h in ^table_name,
              where: h.page_ptr_id == page.id
    query = case is_atom(content) do
      true -> from [_page, h] in query, select: field(h, ^content)
      false -> from [_page, h] in query, select: map(h, ^content)
    end

    CMSRepo.one query
  end

  def get_image_url(col_name, view) do
    image_id = "#{col_name}_id"
      |> String.to_atom
      |> get_content(view)
    url = "wagtailimages_image"
      |> where([image], image.id == ^image_id)
      |> select([image], image.file)
      |> CMSRepo.one

    "https://s3.amazonaws.com/#{@bucket_name}/#{url}"
  end

  def get_tags(topic \\ nil)
  def get_tags(topic) when topic == nil do
    tag_query = from tag in "taggit_tag",
      join: rc in ^"resources_issuetag",
      join: ra in ^"resources_reasontag",
      join: rco in ^"resources_contenttag",
      join: rt in ^"resources_topictag",
      where: tag.id in [rc.tag_id, ra.tag_id, rco.tag_id, rt.tag_id],
      select: %{
        issue: rc.tag_id, reason: ra.tag_id, topic: rt.tag_id,
        content: rco.tag_id, name: tag.name, id: tag.id
      },
      order_by: tag.id,
      distinct: tag.id

    tag_query
    |> CMSRepo.all
    |> Enum.reduce(%{}, fn %{
        reason: aud, issue: cat, content: con, id: id, name: name, topic: topic
      }, acc ->
      cond do
        aud == id -> Map.merge acc,
          %{reason: Map.get(acc, :reason, []) ++ [name]}
        cat == id -> Map.merge acc,
          %{issue: Map.get(acc, :issue, []) ++ [name]}
        con == id -> Map.merge acc,
          %{content: Map.get(acc, :content, []) ++ [name]}
        topic == id -> Map.merge acc,
          %{topic: Map.get(acc, :topic, []) ++ [name]}
      end
    end)
  end

  def get_tags(topic) when is_binary topic do
    topic
    |> String.split(",")
    |> get_tags
  end

  def get_tags(topic) when is_list topic do
    query =
      from t in "taggit_tag",
      join: top in "resources_topictag",
      where: t.name in ^topic and top.tag_id == t.id,
      join: r in "resources_resourcepage",
      where: r.page_ptr_id == top.content_object_id,
      select: %{
        id: r.page_ptr_id,
        heading: r.heading,
        url: r.resource_url,
        body: r.body,
        video: r.video_url,
        priority: r.priority
      }

    query
    |> CMSRepo.all
    |> Enum.map(&(&1 |> get_all_tags("resource", false) |> Map.get(:tags)))
    |> Enum.reduce(%{
      "content" => [], "reason" => [], "issue" => [], "topic" => []
    }, fn el, acc -> merge_lists(acc, el) end)
    |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
  end

  @doc """
    iex> merge_lists(%{"content" => ["community"], "topic" => ["sleep"]}, %{"content" => ["CBT"], "topic" => ["anxiety"]})
    %{"content" => ["community", "CBT"], "topic" => ["sleep", "anxiety"]}
  """

  def merge_lists(el1, el2),
    do: Map.new el1, fn {k, list} -> {k, Enum.uniq(list ++ el2[k])} end

  def get_all_filtered_resources(filter, session_id) do
    "resource"
    |> all_query
    |> get_resources("resource", session_id)
    |> Enum.filter(&filter_by_topic(&1, filter))
    |> Enum.filter(&filter_by_issue(&1, filter))
    |> Enum.filter(&filter_tags(&1, filter))
    |> sort_priority
  end

  def filter_by_topic(
    %{tags: %{"topic" => topic}},
    %{"topic" => topics}), do: Enum.any? topic, &(&1 in topics)
  def filter_by_topic(_params, _filter), do: true

  def filter_by_issue(
    %{tags: %{"issue" => issue}},
    %{"issue" => issues}), do: Enum.any? issue, &(&1 in issues)
  def filter_by_issue(_params, _filter), do: true

  def filter_tags(%{tags: tags}, filter) do
    tags
    |> Map.delete("issue")
    |> Map.delete("topic")
    |> Enum.all?(fn {tag_type, tags} ->
      !Map.has_key?(filter, tag_type) ||
      Enum.any? tags, &(&1 in filter[tag_type])
    end)
  end

  def all_query(type) do
    from r in "#{type}s_#{type}page",
      select: %{
        id: r.page_ptr_id,
        heading: r.heading,
        url: r.resource_url,
        body: r.body,
        video: r.video_url,
        priority: r.priority
      }
  end

  def get_resources(query, type, lm_session) do
    query
      |> CMSRepo.one
      |> Enum.map(&get_all_tags(&1, type))
      |> Enum.map(&get_all_likes(&1, lm_session))
  end

  def get_single_resource(conn, id) do
    session = get_session conn, :lm_session

    query = from r in "resources_resourcepage",
      where: r.page_ptr_id == ^String.to_integer(id),
      select: %{
        id: r.page_ptr_id,
        heading: r.heading,
        url: r.resource_url,
        body: r.body,
        video: r.video_url,
        priority: r.priority
      }

    query
    |> CMSRepo.one
    |> get_all_tags("resource")
    |> get_all_likes(session)
  end

  defp likes_count(data, filter),
    do: data |> Enum.filter_map(filter, &(&1.value)) |> Enum.sum

  def get_all_likes(%{id: article_id} = map, lm_session) do
    likequery = from l in Likes,
            where: l.article_id == ^article_id,
            select: %{value: l.like_value, session_id: l.user_hash}

    likesdata = Repo.all likequery

    likes = likes_count(likesdata, &(&1.value > 0))
    dislikes = likes_count(likesdata, &(&1.value < 0))

    liked = case Enum.find likesdata, &(&1.session_id == lm_session) do
      nil -> "none"
      %{value: value} -> value
    end

    Map.merge map, %{likes: likes, dislikes: dislikes, liked: liked}
  end

  def get_all_tags(resource, type, all \\ true) do
    tags =
      ["issue", "reason", "content", "topic"]
        |> Enum.map(&create_query(&1, resource, type))
        |> Enum.map(fn {type, query} -> {type, CMSRepo.all(query)} end)
        |> Enum.map(&add_all_filter &1, all)
        |> Map.new
    Map.merge(%{tags: tags}, resource)
  end

  def add_all_filter(tags, false), do: tags
  def add_all_filter({type, list}, true),
    do: {type, list ++ ["all-#{type}"]}

  def create_query(tag_type, resource, type) do
    query = from t in "taggit_tag",
      left_join: tt in ^"#{type}s_#{tag_type}tag",
      where: t.id == tt.tag_id,
      where: ^resource.id == tt.content_object_id,
      select: t.name,
      distinct: t.name

    {tag_type, query}
  end
end
