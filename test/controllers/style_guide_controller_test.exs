defmodule App.StyleGuideControllerTest do
  use App.ConnCase

  test "GET /styleguide", %{conn: conn} do
    conn = get conn, "/styleguide"
    assert html_response(conn, 200) =~ "<!DOCTYPE html>"
  end
end
