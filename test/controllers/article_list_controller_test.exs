defmodule App.ArticleControllerTest do
  use App.ConnCase

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, article_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Articles"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    conn = get conn, article_path(conn, :show, "non-existent")
    assert html_response(conn, 404) =~ "not found"
  end
end
