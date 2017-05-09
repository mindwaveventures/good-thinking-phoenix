defmodule App.StyleGuideControllerTest do
  use App.ConnCase

  setup config do
    login_user(config)
  end

  @tag login_as: "me@test.com"
  test "GET /styleguide", %{conn: conn} do
    conn = get conn, "/styleguide"
    assert html_response(conn, 200) =~ "<!DOCTYPE html>"
  end
end
