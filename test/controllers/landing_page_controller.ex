defmodule App.LandingPageControllerTest do
  use App.ConnCase

  test "GET /sleep", %{conn: conn} do
    conn = get conn, "/sleep"
    assert html_response(conn, 200) =~ "sleep"
  end
end
