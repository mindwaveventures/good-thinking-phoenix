defmodule App.InfoViewTest do
  use App.ConnCase

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(Router, :browser)
      |> get("/")
    {:ok, %{conn: conn}}
  end

    test "transform single image string", %{conn: conn} do
      assert App.InfoView.renderImage(~s(<embed alt="hellos" embedtype="image" format="left" id="2"/>), conn) ==
      ~s(<img src="/images/LDMW_Assets_Crisis_abKUOsH.png" alt="hellos" class="fl" />)
    end

    test "transform multiple image strings", %{conn: conn} do
      assert App.InfoView.renderImage(~s(<div><embed alt="hellos" embedtype="image" format="left" id="2"/></div><div><embed alt="world" embedtype="image" format="right" id="3"/></div>), conn) ==
      ~s(<div><img src="/images/LDMW_Assets_Crisis_abKUOsH.png" alt="hellos" class="fl" /></div><div><img src="/images/Screen_Shot_2017-04-20_at_17.15.42.png" alt="world" class="fr" /></div>)
    end
end
