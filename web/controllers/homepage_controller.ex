defmodule App.HomepageController do
  use App.Web, :controller
  import Ecto.Query, only: [from: 2]
  alias App.CMSRepo

  def index(conn, _params) do
    body = get_body()

    tag_query = from h in "articles_articlepagetag",
      join: tag in "taggit_tag",
      where: h.tag_id == tag.id,
      select: {tag.id, tag.name},
      order_by: tag.id,
      distinct: tag.id

    tags = CMSRepo.all(tag_query)

    render conn, "index.html", body: body, tags: tags
  end

  def get_body() do
    id_query = from page in "wagtailcore_page",
      where: page.url_path == "/home/",
      select: page.id

    page_id = CMSRepo.one(id_query)

    content_query = from page in "home_homepage",
      where: page.page_ptr_id == ^page_id,
      select: page.body

    CMSRepo.one(content_query)
  end
end
