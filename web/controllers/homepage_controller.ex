defmodule App.HomepageController do
  use App.Web, :controller
  import Ecto.Query, only: [from: 2]
  alias App.CMSRepo

  def index(conn, _params) do
    id_query = from page in "wagtailcore_page",
      where: page.url_path == "/home/",
      select: page.id

    page_id = CMSRepo.one(id_query)

    content_query = from page in "home_homepage",
      where: page.page_ptr_id == ^page_id,
      select: page.body

    render conn, "index.html", body: CMSRepo.one(content_query)
  end
end
