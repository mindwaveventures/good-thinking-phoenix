defmodule App.InfoView do
  use App.Web, :view

  import Ecto.Query, only: [from: 2]

  alias App.CMSRepo

  # Regex to match wagtail embedded image and pull out title, id and format
  @embed_regex ~r/<embed\salt=\"([^\"]+)\"\sembedtype=\"image\"\sformat=\"([^\"]+)\"\sid=+\"([^\"]+)\"\/>/

  def renderImage(html_string, conn) do
      Regex.replace(@embed_regex, html_string,
        &get_img_tag(conn, &1, &2, &3, &4), global: true
      )
  end

  def get_img_tag(conn, _embed, alt, align, id) do
    image_query = from i in "wagtailimages_image",
    where: i.id == ^String.to_integer(id),
    select: i.file

    # Temporary - uses image in filesystem until we have image uploads to aws
    img_src =
      image_query
      |> CMSRepo.one
      |> String.replace("original_images", "/images")

    img_class =
      case align do
        "left" -> "fl"
        "right" -> "fr"
        _ -> ""
      end

      "<img src=\"#{static_path(conn, img_src)}\"" <>
      "alt=\"#{alt}\" class=\"#{img_class}\" />"
    end
end
