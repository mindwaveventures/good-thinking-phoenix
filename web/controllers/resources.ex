defmodule App.Resources do
  @moduledoc """
  # Functions for querying CMS Database for resources
  """

  use App.Web, :controller

  alias App.{CMSRepo, Repo, Likes}

  def get_all_resources(type) do
    query = from r in "#{type}s_#{type}page",
      select: %{
        id: r.page_ptr_id,
        heading: r.heading,
        url: r.resource_url,
        body: r.body,
        priority: r.priority
      }

      query
      |> CMSRepo.all
      |> Enum.map(&(Map.merge(&1, %{type: "#{type}s"})))
      |> Enum.map(&get_all_tags/1)
      |> Enum.map(&get_all_likes/1)
      |> Enum.sort(&(&1[:priority] <= &2[:priority]))
  end

  def get_all_likes(map) do
    %{id: article_id} = map
    query = from l in Likes,
            where: l.article_id == ^article_id,
            select: l.like_value
    likes = query |> Repo.all |> Enum.sum
    Map.merge(map, %{likes: likes})
  end

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

  def get_all_tags(resource) do
    query = from t in "taggit_tag",
      left_join: cat in ^"#{resource.type}_categorytag",
      on: t.id == cat.tag_id,
      left_join: cot in ^"#{resource.type}_contenttag",
      on: t.id == cot.tag_id,
      left_join: aut in ^"#{resource.type}_audiencetag",
      on: t.id == aut.tag_id,
      where: ^resource.id == cat.content_object_id
      or ^resource.id == cot.content_object_id
      or ^resource.id == aut.content_object_id,
      select: t.name,
      distinct: t.name

    Map.merge(%{tags: CMSRepo.all(query)}, resource)
  end

  def filter_tags(resources, audience_filter, content_filter) do
    Enum.filter(resources, fn e ->
      Enum.all?(audience_filter, fn a -> a in e.tags end) and
      Enum.all?(content_filter, fn c -> c in e.tags end)
    end)
  end
end
