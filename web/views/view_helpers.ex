defmodule App.ViewHelpers do
  @moduledoc """
    Functions to transform html as stored in the database by wagtail into
    the html we actually render on the site
  """

  import App.Router.Helpers
  import Ecto.Query, only: [from: 2]

  alias App.CMSRepo

  # Regex to match wagtail embedded image and pull out title, id and format
  @embed_regex ~r/<embed\salt=\"([^\"]+)\"\sembedtype=\"image\"\sformat=\"([^\"]+)\"\sid=+\"([^\"]+)\"\/>/
  @link_regex ~r/<a\sid=\"([^\"]+)\"\slinktype=\"page\">([^<]+)<\/a>/

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
        _ -> "w-50"
      end

    img_tag = "<img src=\"#{static_path(conn, img_src)}\" " <>
      "alt=\"#{alt}\" class=\"#{img_class}\" />"

    case align do
      "fullwidth" -> "<div class=\"w-100 tc\">#{img_tag}</div>"
      _ -> img_tag
    end
  end

  def renderLink(html_string) do
    Regex.replace(@link_regex, html_string, &get_a_tag/3, global: true)
  end

  def get_a_tag(_full_string, id, text) do
    link_query = from p in "wagtailcore_page",
      where: p.id == ^String.to_integer(id),
      join: c in "django_content_type",
      where: p.content_type_id == c.id,
      select: %{content: c.app_label, page: p.slug}

    data = CMSRepo.one(link_query)

    "<a href=\"/#{data.content}/#{data.page}\">#{text}</a>"
  end
end
