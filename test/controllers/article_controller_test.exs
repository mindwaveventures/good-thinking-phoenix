defmodule App.ArticleControllerTest do
  use App.ConnCase

  @existing_resource_id 11
  @nonexisting_resource_id 99
  test "GET /article/#{@existing_resource_id}", %{conn: conn} do
    conn = get conn, "/article/#{@existing_resource_id}"
    assert html_response(conn, 200) =~ "<!DOCTYPE html>"
  end

  test "GET /article/#{@nonexisting_resource_id}", %{conn: conn} do
    conn = get conn, "/article/#{@nonexisting_resource_id}"
    assert html_response(conn, 404)
  end
end
