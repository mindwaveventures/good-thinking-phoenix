defmodule App.PageControllerTest do
  use App.ConnCase, async: false

  import Mock
  alias App.CMSRepo

  @body "<h1>BODY</h1>"
  @tags 1..4 |> Enum.to_list |> Enum.map(&("tag#{&1}"))

  test "GET /", %{conn: conn} do
    with_mock CMSRepo, [all: fn(_) -> @tags end, one: fn(_) -> @body end] do
      conn = get conn, "/"
      assert html_response(conn, 200) =~ "<!DOCTYPE html>"
    end
  end
end
