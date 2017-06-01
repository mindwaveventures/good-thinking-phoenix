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

  def render_image(html_string, conn) do
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

    img_tag = ~s(<img src="#{static_path(conn, img_src)}" alt="#{alt}" class="#{img_class}" />)

    case align do
      "fullwidth" -> "<div class=\"w-100 tc\">#{img_tag}</div>"
      _ -> img_tag
    end
  end

  def render_link(html_string) do
    Regex.replace(@link_regex, html_string, &get_a_tag/3, global: true)
  end

  def get_a_tag(_full_string, id, text) do
    link_query = from p in "wagtailcore_page",
      where: p.id == ^String.to_integer(id),
      join: c in "django_content_type",
      where: p.content_type_id == c.id,
      select: %{content: c.app_label, page: p.slug}

    data = CMSRepo.one(link_query)

    ~s(<a href="/#{data.content}/#{data.page}">#{text}</a>)
  end

  def get_class(component, background \\ "light") do
    case component do
      "primary_button" -> "f5 fw6 link dib ph3 pv2 br-pill lm-white-hover lm-dark-blue lm-bg-orange pointer button segoe-bold tracked"
      "secondary_button" ->
        case background do
          "dark" -> "f5 link dib ph3 pv2 br-pill lm-bg-dark-blue lm-white-hover b--lm-white-hover lm-orange pointer ba bw1 b--lm-orange segoe-bold tracked"
          _ -> "f5 link dib ph3 pv2 br-pill lm-bg-white lm-white-hover lm-bg-dark-blue-hover lm-dark-blue pointer ba bw1 b--lm-dark-blue segoe-bold tracked"
        end
    end
  end
end
