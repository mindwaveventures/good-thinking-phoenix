defmodule App.InfoView do
  use App.Web, :view

  import Ecto.Query, only: [from: 2]

  alias App.CMSRepo

  # Regex to match wagtail embed and pull out title, id and format
  @embed_regex ~r/<embed\salt=\"(.+)\".+embedtype=\"image\".+format=\"(.+)\".+id=+\"(.+)\"\/>/

  def renderImage(html_string, conn) do
    [embed, alt, align, id] =
      Regex.run(@embed_regex, html_string)

      image_query = from i in "wagtailimages_image",
        where: i.id == ^String.to_integer(id),
        select: i.file

      # Temporary - uses image in filesystem until we have image uploads to aws
      img_src =
        image_query
        |> CMSRepo.one
        |> String.replace("original_images", "/images")

      Regex.replace(@embed_regex, html_string,
        "<img src=\"#{static_path(conn, img_src)}\" alt=\"#{alt}\"/>"
      )
  end
end
