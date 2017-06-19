defmodule App.CrisisControllerTest do
  use App.ConnCase

  test "GET /crisis", %{conn: conn} do
    conn = get conn, "/crisis"
    assert html_response(conn, 200) =~ "ALPHA"
  end
end
