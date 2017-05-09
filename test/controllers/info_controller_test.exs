defmodule App.InfoControllerTest do
  use App.ConnCase

  setup config, do: login_user(config)

  @tag login_as: "me@test.com"
  test "GET /info/crisis", %{conn: conn} do
    conn = get conn, "/info/crisis"
    assert html_response(conn, 200) =~ "What to do in a crisis"
  end

  @tag login_as: "me@test.com"
  test "GET /info/notfound", %{conn: conn} do
    conn = get conn, "/info/notfound"
    assert html_response(conn, 404)
  end
end
