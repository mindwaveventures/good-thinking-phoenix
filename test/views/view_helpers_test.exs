defmodule App.ViewHelpersTest do
  use App.ConnCase

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(Router, :browser)
      |> get("/")
    {:ok, %{conn: conn}}
  end

  test "transform single image string", %{conn: conn} do
    assert App.ViewHelpers.renderImage(~s(<embed alt="hellos" embedtype="image" format="left" id="2"/>), conn) ==
    ~s(<img src="/images/LDMW_Assets_Crisis_abKUOsH.png" alt="hellos" class="fl" />)
  end

  test "transform single image string - full width", %{conn: conn} do
    assert App.ViewHelpers.renderImage(~s(<embed alt="hellos" embedtype="image" format="fullwidth" id="2"/>), conn) ==
    ~s(<div class="w-100 tc"><img src="/images/LDMW_Assets_Crisis_abKUOsH.png" alt="hellos" class="w-50" /></div>)
  end

  test "transform multiple image strings", %{conn: conn} do
    assert App.ViewHelpers.renderImage(~s(<div><embed alt="hellos" embedtype="image" format="left" id="2"/></div><div><embed alt="world" embedtype="image" format="right" id="3"/></div>), conn) ==
    ~s(<div><img src="/images/LDMW_Assets_Crisis_abKUOsH.png" alt="hellos" class="fl" /></div><div><img src="/images/Screen_Shot_2017-04-20_at_17.15.42.png" alt="world" class="fr" /></div>)
  end

  test "transform single link" do
    assert App.ViewHelpers.renderLink(~s(<a id="11" linktype="page">link</a>)) ==
    ~s(<a href="/info/crisis">link</a>)
  end

  test "transform multiple links" do
    assert App.ViewHelpers.renderLink(~s(<div><a id="11" linktype="page">link</a></div><div><a id="12" linktype="page">link2</a></div>)) ==
    ~s(<div><a href="/info/crisis">link</a></div><div><a href="/info/coming-soon">link2</a></div>)
  end
end
