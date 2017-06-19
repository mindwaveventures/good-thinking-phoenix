defmodule App.ViewHelpersTest do
  use App.ConnCase
  # doctest App.ViewHelpers, import: true

  import App.ViewHelpers

  alias Plug.Conn

  @image_link "https://s3.amazonaws.com/londonminds/original_images/0049_-30463-31450.jpg"
  @image_id 1
  @crisis_page_id 12

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(Router, :browser)
      |> Conn.put_req_header("user-agent", "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET4.0C; .NET4.0E)")
      |> get("/")
    {:ok, %{conn: conn}}
  end

  test "transform single image string", %{conn: conn} do
    actual = render_image(~s(<embed alt="hellos" embedtype="image" format="left" id="#{@image_id}"/>), conn)
    expected = ~s(<div class="tl"><img src="#{@image_link}" alt="hellos" class="w-50" /></div>)

    assert actual == expected
  end

  test "transform single image string - full width", %{conn: conn} do
    actual = render_image(~s(<embed alt="hellos" embedtype="image" format="fullwidth" id="#{@image_id}"/>), conn)
    expected = ~s(<div class="tc"><img src="#{@image_link}" alt="hellos" class="w-100" /></div>)

    assert actual == expected
  end

  test "transform multiple image strings", %{conn: conn} do
    actual = render_image(~s(<div><embed alt="hellos" embedtype="image" format="left" id="#{@image_id}"/></div><div><embed alt="world" embedtype="image" format="right" id="#{@image_id}"/></div>), conn)
    expected = ~s(<div><div class="tl"><img src="#{@image_link}" alt="hellos" class="w-50" /></div></div><div><div class="tr"><img src="#{@image_link}" alt="world" class="w-50" /></div></div>)

    assert actual == expected
  end

  test "non-exisitent image", %{conn: conn} do
    actual = render_image(~s(<embed alt="hellos" embedtype="image" format="left" id="0"/>), conn)
    expected = ~s(<div class="tl"><img src="/not-found" alt="hellos" class="w-50" /></div>)

    assert actual == expected
  end

  test "transform single link" do
    actual = render_link(~s(<a id="#{@crisis_page_id}" linktype="page">link</a>))
    expected = ~s(<a href="/crisis" class="" id="">link</a>)

    assert actual == expected
  end

  test "transform multiple links" do
    actual = render_link(~s(<div><a id="#{@crisis_page_id}" linktype="page">link</a></div><div><a id="#{@crisis_page_id}" linktype="page">link2</a></div>))
    expected = ~s(<div><a href="/crisis" class="" id="">link</a></div><div><a href="/crisis" class="" id="">link2</a></div>)

    assert actual == expected
  end

  test "transform link with class" do
    actual = render_link(~s(<a id="#{@crisis_page_id}" linktype="page">link</a>), class: "f5 white")
    expected = ~s(<a href="/crisis" class="f5 white" id="">link</a>)

    assert actual == expected
  end

  test "transform link with id" do
    actual = render_link(~s(<a id="#{@crisis_page_id}" linktype="page">link</a>), id: "hello")
    expected = ~s(<a href="/crisis" class="" id="hello">link</a>)

    assert actual == expected
  end

  test "transform bold link" do
    actual =
      ~s(<p><b><a id="#{@crisis_page_id}" linktype="page">link</a></b></p>)
      |> render_link(class: "f5 white")
      |> handle_bold
    expected = ~s(<p><b class="nunito-bold"><a href="/crisis" class="f5 white" id="">link</a></b></p>)

    assert actual == expected
  end

  test "transform large html string", %{conn: conn} do
    actual =
      ~s"""
      <h1><a id="#{@crisis_page_id}" linktype="page">Link title</a></h1>\
      <a id="#{@crisis_page_id}" linktype="page"><embed alt="hello" embedtype="image" format="left" id="#{@image_id}"/></a>\
      <p><a id="#{@crisis_page_id}" linktype="page"><b>Link P</b></a></p>\
      <h1><b><a id="#{@crisis_page_id}" linktype="page">Link title 2</a></b></h1>
      """
      |> transform_html(conn)
    expected = {:safe,
      ~s"""
      <h1><a href="/crisis" class="" id="">Link title</a></h1>\
      <a href="/crisis" class="" id=""><div class="tl"><img src="#{@image_link}" alt="hello" class="w-50" /></div></a>\
      <p><a href="/crisis" class="" id=""><b class="nunito-bold">Link P</b></a></p>\
      <h1><b class="segoe-bold"><a href="/crisis" class="" id="">Link title 2</a></b></h1>
      """}

      assert actual == expected
  end

  test "handle bold - nested" do
    actual = handle_bold "<h1>Hello <b>World</b></h1><p>more <b>text</b> is <b>here</b></p>"
    expected = ~s(<h1>Hello <b class="segoe-bold">World</b></h1><p>more <b class="nunito-bold">text</b> is <b class="nunito-bold">here</b></p>)

    assert actual == expected
  end

  test "handle bold header " do
    actual = handle_bold("<h1><b>Hello World</b></h1>")
    expected = ~s(<h1><b class="segoe-bold">Hello World</b></h1>)

    assert actual == expected
  end

  test "handle bold paragraph" do
    actual = handle_bold "<p><b>Hello World</b></p>"
    expected = ~s(<p><b class="nunito-bold">Hello World</b></p>)

    assert actual == expected
  end

  test "ie8", %{conn: conn} do
    assert is_ie8? conn
  end
end
