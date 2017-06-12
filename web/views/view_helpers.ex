defmodule App.ViewHelpers do
  @moduledoc """
    Functions to transform html as stored in the database by wagtail into
    the html we actually render on the site
  """

  import App.Router.Helpers
  import Ecto.Query, only: [from: 2]
  import Phoenix.HTML, only: [raw: 1]

  alias App.CMSRepo

  # Regex to match wagtail embedded image and pull out title, id and format
  @embed_regex ~r/<embed\salt=\"([^\"]+)\"\sembedtype=\"image\"\sformat=\"([^\"]+)\"\sid=+\"([^\"]+)\"\/>/
  @link_regex ~r/<a\sid=\"([^\"]+)\"\slinktype=\"page\">((?!<\/a>).*?)<\/a>/

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
      |> case do
        nil -> nil
        str ->
          String.replace str, "original_images", "https://s3.amazonaws.com/londonminds/original_images"
      end

    img_class =
      case align do
        "left" -> {"tl", "w-50"}
        "right" -> {"tr", "w-50"}
        _ -> {"tc", "w-100"}
      end

    src = case img_src != nil and String.starts_with? img_src, "https://" do
      true ->
        img_src
      false ->
        (img_src && static_path(conn, img_src)) || "/not-found"
    end

    ~s(<div class="#{elem(img_class, 0)}"><img src="#{src}" alt="#{alt}" class="#{elem(img_class, 1)}" /></div>)
  end

  def render_link(html_string, opts \\ %{}) do
    Regex.replace @link_regex, html_string,
      &get_a_tag(&1, &2, &3, opts[:class], opts[:id]), global: true
  end

  def get_a_tag(_full_string, id, text, classes \\ "", html_id \\ "") do
    link_query = from p in "wagtailcore_page",
      where: p.id == ^String.to_integer(id),
      join: c in "django_content_type",
      where: p.content_type_id == c.id,
      select: %{content: c.app_label, page: p.slug}

    data = CMSRepo.one(link_query)

    ~s(<a href="/#{data.page}" class="#{classes}" id="#{html_id}">#{text}</a>)
  end

  @nunito_tags 1..6 |> Enum.to_list |> Enum.map(&("h#{&1}"))
  @segio_tags ~w(p li)
  @tags Enum.join @nunito_tags ++ @segio_tags, "|"
  @doc """
  iex> handle_bold("<h1>Hello <b>World</b></h1><p>more <b>text</b> is <b>here</b></p>") == ~s(<h1>Hello <b class="nunito">World</b></h1><p>more <b class="segoe-bold">text</b> is <b class="segoe-bold">here</b></p>)
  true
  iex> handle_bold("<h1><b>Hello World</b></h1>") == ~s(<h1><b class="nunito">Hello World</b></h1>)
  true
  iex> handle_bold("<p><b>Hello World</b></p>") == ~s(<p><b class="segoe-bold">Hello World</b></p>)
  true
  """
  def handle_bold(string) when is_binary(string) do
    case String.contains? string, "<b>" do
      true ->
        "<(#{@tags})>(.*?(?=(?:<\/\\1>)))<\/\\1>"
          |> Regex.compile!
          |> Regex.replace(string, &handle_bold(&1, &2, &3))
      false -> string
    end
  end
  def handle_bold(_match, tag, inner_html) do
    inner = cond do
      tag in @nunito_tags -> handle_bold(inner_html, "nunito")
      tag in @segio_tags -> handle_bold(inner_html, "segoe")
    end

    "<#{tag}>#{inner}</#{tag}>"
  end
  def handle_bold(inner_html, tag_type),
    do: String.replace inner_html, "<b>", ~s(<b class="#{tag_type}-bold">)

  def transform_html(html_string, conn, opts \\ %{}) do
    html_string
    |> render_link(opts)
    |> render_image(conn)
    |> handle_bold
    |> raw
  end

  @button_classes "f5 link dib ph3 pv2 br-pill lm-white-hover pointer segoe-bold tracked"
  def get_class("primary_button"),
    do: @button_classes <> "fw6 lm-dark-blue lm-bg-orange button"
  def get_class("secondary_button", "light"),
    do: @button_classes <> "lm-bg-white lm-bg-dark-blue-hover lm-dark-blue ba bw1 b--lm-dark-blue"
  def get_class("secondary_button", "dark"),
    do: @button_classes <> "lm-bg-dark-blue b--lm-white-hover lm-orange ba bw1 b--lm-orange"
  def get_class("secondary_button", nil), do: get_class("secondary_button", "light")
end
