defmodule App.ArticleControllerTest do
  use App.ConnCase, async: false

  import Mock
  alias App.CMSRepo

  @articles 1..4 |> Enum.to_list |> Enum.map(&("article#{&1}"))
  @emptyarticles []

  test "lists all entries on index", %{conn: conn} do
    with_mock CMSRepo, [all: fn(_) -> @articles end] do
      conn = get conn, article_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Articles"
    end
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    with_mock CMSRepo, [all: fn(_) -> @emptyarticles end] do
      conn = get conn, article_path(conn, :show, "non-existent")
      assert html_response(conn, 404) =~ "not found"
    end
  end
end
