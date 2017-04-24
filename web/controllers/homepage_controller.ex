defmodule App.HomepageController do
  use App.Web, :controller
  import Ecto.Query, only: [from: 2]
  alias App.CMSRepo

  defp homesubpages({_id, _title, "/home/" <> url}), do: url != ""
  defp homesubpages(_tuple), do: false

  def index(conn, _params) do
    id_query = from page in "wagtailcore_page",
      where: page.url_path == "/home/",
      select: page.id

    page_id = CMSRepo.one(id_query)

    content_query = from page in "home_homepage",
      where: page.page_ptr_id == ^page_id,
      select: page.body

    body = CMSRepo.one(content_query)

    content_query = from page in "home_homepage",
      where: page.page_ptr_id == ^page_id,
      select: page.footer

    footer = CMSRepo.one(content_query)

    pages_query = from page in "wagtailcore_page",
      select: {page.id, page.title, page.url_path}

    wagtail_pages = CMSRepo.all(pages_query)

    tags = wagtail_pages
      |> Enum.filter(&homesubpages/1)
      |> Enum.map(fn {id, title, _url} ->
        %{id: id, title: title}
      end)

    render conn, "index.html", body: body, tags: tags, footer: footer
  end

  def show(conn, %{"id" => id_str}) do
    id = String.to_integer(id_str)
    tag_query = from page in "home_homepage",
      where: page.page_ptr_id == ^id,
      select: page.body
    tag_content = CMSRepo.one(tag_query)

    render conn, "tag.html", content: tag_content
  end
end
