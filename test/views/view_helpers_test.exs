defmodule App.ViewHelpersTest do
  use App.ConnCase

  import App.ViewHelpers, only: [render_image: 2, render_link: 1]

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

  test "transform single link" do
    actual = render_link(~s(<a id="30" linktype="page">link</a>))
    expected = ~s(<a href="/info/crisis">link</a>)

    assert actual == expected
  end

  test "transform multiple links" do
    actual = render_link(~s(<div><a id="30" linktype="page">link</a></div><div><a id="30" linktype="page">link2</a></div>))
    expected = ~s(<div><a href="/info/crisis">link</a></div><div><a href="/info/crisis">link2</a></div>)

    assert actual == expected
  end
end
