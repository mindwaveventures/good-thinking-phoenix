defmodule App.ViewHelpersTest do
  use App.ConnCase

  import App.ViewHelpers

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(Router, :browser)
      |> get("/")
    {:ok, %{conn: conn}}
  end

  test "transform single image string", %{conn: conn} do
    actual = render_image(~s(<embed alt="hellos" embedtype="image" format="left" id="1"/>), conn)
    expected = ~s(<img src="/images/phoenix.png" alt="hellos" class="fl" />)

    assert actual == expected
  end

  test "transform single image string - full width", %{conn: conn} do
    actual = render_image(~s(<embed alt="hellos" embedtype="image" format="fullwidth" id="1"/>), conn)
    expected = ~s(<div class="w-100 tc"><img src="/images/phoenix.png" alt="hellos" class="w-50" /></div>)

    assert actual == expected
  end

  test "transform multiple image strings", %{conn: conn} do
    actual = render_image(~s(<div><embed alt="hellos" embedtype="image" format="left" id="1"/></div><div><embed alt="world" embedtype="image" format="right" id="1"/></div>), conn)
    expected = ~s(<div><img src="/images/phoenix.png" alt="hellos" class="fl" /></div><div><img src="/images/phoenix.png" alt="world" class="fr" /></div>)

    assert actual == expected
  end

  test "non-exisitent image", %{conn: conn} do
    actual = render_image(~s(<embed alt="hellos" embedtype="image" format="left" id="0"/>), conn)
    expected = ~s(<img src="/not-found" alt="hellos" class="fl" />)

    assert actual == expected
  end

  test "transform single link" do
    actual = render_link(~s(<a id="30" linktype="page">link</a>))
    expected = ~s(<a href="/crisis" class="" id="">link</a>)

    assert actual == expected
  end

  test "transform multiple links" do
    actual = render_link(~s(<div><a id="30" linktype="page">link</a></div><div><a id="30" linktype="page">link2</a></div>))
    expected = ~s(<div><a href="/crisis" class="" id="">link</a></div><div><a href="/crisis" class="" id="">link2</a></div>)

    assert actual == expected
  end

  test "transform link with class" do
    actual = render_link(~s(<a id="30" linktype="page">link</a>), class: "f5 white")
    expected = ~s(<a href="/crisis" class="f5 white" id="">link</a>)

    assert actual == expected
  end

  test "transform link with id" do
    actual = render_link(~s(<a id="30" linktype="page">link</a>), id: "hello")
    expected = ~s(<a href="/crisis" class="" id="hello">link</a>)

    assert actual == expected
  end

  test "transform bold link" do
    actual =
      ~s(<p><b><a id="30" linktype="page">link</a></b></p>)
      |> render_link(class: "f5 white")
      |> handle_bold
    expected = ~s(<p><b class="segoe-bold"><a href="/crisis" class="f5 white" id="">link</a></b></p>)

    assert actual == expected
  end

  test "transform large html string", %{conn: conn} do
    actual =
      ~s"""
      <h1><a id="30" linktype="page">Link title</a></h1>\
      <a id="30" linktype="page"><embed alt="hello" embedtype="image" format="left" id="1"/></a>\
      <p><a id="30" linktype="page"><b>Link P</b></a></p>\
      <h1><b><a id="30" linktype="page">Link title 2</a></b></h1>
      """
      |> transform_html(conn)
    expected = {:safe,
      ~s"""
      <h1><a href="/crisis" class="" id="">Link title</a></h1>\
      <a href="/crisis" class="" id=""><img src="/images/phoenix.png" alt="hello" class="fl" /></a>\
      <p><a href="/crisis" class="" id=""><b class="segoe-bold">Link P</b></a></p>\
      <h1><b class="nunito-bold"><a href="/crisis" class="" id="">Link title 2</a></b></h1>
      """}

      assert actual == expected
  end
end
