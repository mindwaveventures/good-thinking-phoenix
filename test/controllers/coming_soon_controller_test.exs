defmodule App.ComingSoonControllerTest do
  use App.ConnCase

  test "GET /coming-soon", %{conn: conn} do
    conn = get conn, "/coming-soon"
    assert html_response(conn, 200) =~ "coming soon"
  end
end
