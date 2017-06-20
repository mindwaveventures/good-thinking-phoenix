defmodule App.CrisisController do
  use App.Web, :controller

  def index(conn, _params) do
    query = from i in "crisis_crisispage",
      join: w in "wagtailcore_page",
      where: i.page_ptr_id == w.id and w.slug == "crisis",
      select: %{
        heading: i.heading,
        body: i.body
      }

    data = CMSRepo.one query

    render conn, "index.html", heading: data.heading, body: data.body
  end
end
