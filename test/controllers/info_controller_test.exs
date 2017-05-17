defmodule App.InfoControllerTest do
  use App.ConnCase

  test "GET /info/crisis", %{conn: conn} do
    conn = get conn, "/info/crisis"
    assert html_response(conn, 200) =~ "ALPHA"
  end

  test "GET /info/notfound", %{conn: conn} do
    conn = get conn, "/info/notfound"
    assert html_response(conn, 404)
  end
end
