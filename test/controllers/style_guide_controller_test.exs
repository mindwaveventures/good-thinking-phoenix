defmodule App.StyleGuideControllerTest do
  use App.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/styleguide"
    assert html_response(conn, 200) =~ "<!DOCTYPE html>"
  end
end
