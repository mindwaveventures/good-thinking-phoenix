defmodule App.Resources do
  @moduledoc """
  # Functions for querying CMS Database for resources
  """

  use App.Web, :controller

  alias App.{CMSRepo, Repo, Likes}

  def true_tuples({_t, "true"}), do: true
  def true_tuples({_t, "false"}), do: false
  def first_value({a, "true"}), do: a
  def sort_priority(list) do
    Enum.sort(list, &(&1[:priority] <= &2[:priority]))
  end

  @types ["article", "resource"]
  def handle_article_or_resource(tag, type, lm_session) when type in @types do
    tag
    |> create_tag_query(type)
    |> get_resources(type, lm_session)
  end

  def get_content(content) do
    query = from page in "wagtailcore_page",
      where: page.url_path == "/home/",
      join: h in "home_homepage",
      where: h.page_ptr_id == page.id,
      select: %{alphatext: h.alphatext,
                body: h.body,
                footer: h.footer,
                lookingfor: h.lookingfor}

    query
    |> CMSRepo.one
    |> Map.get(content)
  end

  def check_tag(tag) do
    query = from t in "taggit_tag",
      where: t.name == ^tag,
      select: t.name
    case name = CMSRepo.one(query) do
      nil -> {:error, "doesn't exist"}
      _ -> {:ok, name}
    end
  end

  def get_tags(type) do
    tag_query = from tag in "taggit_tag",
      full_join: h in ^"articles_#{type}tag",
      full_join: l in ^"resources_#{type}tag",
      where: h.tag_id == tag.id or l.tag_id == tag.id,
      select: tag.name,
      order_by: tag.id,
      distinct: tag.id

    CMSRepo.all tag_query
  end

  def get_all_filtered_resources(tag, filter, session_id) do
    ["article", "resource"]
    |> Enum.map(&(handle_article_or_resource(tag, &1, session_id)))
    |> Enum.concat
    |> Enum.filter(fn %{tags: tags} ->
      Enum.all?(filter, &(&1 in tags))
    end)
    |> sort_priority
  end

  def all_query(type) do
    from r in "#{type}s_#{type}page",
      select: %{
        id: r.page_ptr_id,
        heading: r.heading,
        url: r.resource_url,
        body: r.body,
        priority: r.priority
      }
  end

  def get_resources(query, type, lm_session) do
    query
      |> CMSRepo.all
      |> Enum.map(&get_all_tags(&1, type))
      |> Enum.map(&get_all_likes(&1, lm_session))
  end

  def get_all_likes(%{id: article_id} = map, lm_session) do
    likequery = from l in Likes,
            where: l.article_id == ^article_id,
            select: %{value: l.like_value, session_id: l.user_hash}
    likesdata = likequery |> Repo.all
    likes = Enum.filter_map(likesdata, &(&1.value > 0), &(&1.value)) |> Enum.sum
    dislikes = Enum.filter_map(likesdata, &(&1.value < 0), &(&1.value)) |> Enum.sum
    liked = case Enum.find(likesdata, &(&1.session_id == lm_session)) do
      nil -> "none"
      %{value: value} -> value
    end
    Map.merge map, %{likes: likes, dislikes: dislikes, liked: liked}
  end

  # getting all resources tagged by category tag
  def create_tag_query(tag, type) do
    query = from t in "taggit_tag",
      where: t.name == ^tag,
      join: cat in ^"#{type}s_categorytag",
      where: cat.tag_id == t.id,
      join: a in ^"#{type}s_#{type}page",
      where: a.page_ptr_id == cat.content_object_id

    if type == "resource" do
      query
        |> select([t, cat, a], %{
          id: a.page_ptr_id,
          heading: a.heading,
          url: a.resource_url,
          body: a.body,
          priority: a.priority
        })
    else
      query
        |> select([t, cat, a], %{
          id: a.page_ptr_id,
          heading: a.heading
        })
    end
  end

  def get_all_tags(resource, type) do
    query = from t in "taggit_tag",
      left_join: cat in ^"#{type}s_categorytag",
      on: t.id == cat.tag_id,
      left_join: cot in ^"#{type}s_contenttag",
      on: t.id == cot.tag_id,
      left_join: aut in ^"#{type}s_audiencetag",
      on: t.id == aut.tag_id,
      where: ^resource.id == cat.content_object_id
      or ^resource.id == cot.content_object_id
      or ^resource.id == aut.content_object_id,
      select: t.name,
      distinct: t.name

    Map.merge %{tags: CMSRepo.all(query)}, resource
  end

end
