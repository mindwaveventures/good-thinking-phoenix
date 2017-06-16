defmodule App.StaticControllerTest do
  use App.ConnCase

  test "GET /static", %{conn: conn} do
    conn = get conn, "/static"
    assert html_response(conn, 200) =~ "ALPHA"
  end

  test "GET /notfound", %{conn: conn} do
    conn = get conn, "/notfound"
    assert html_response(conn, 404)
  end
end
