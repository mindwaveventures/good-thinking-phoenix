defmodule App.InfoControllerTest do
  use App.ConnCase

  test "GET /crisis", %{conn: conn} do
    conn = get conn, "/crisis"
    assert html_response(conn, 200) =~ "ALPHA"
  end

  test "GET /notfound", %{conn: conn} do
    conn = get conn, "/notfound"
    assert html_response(conn, 404)
  end
end
