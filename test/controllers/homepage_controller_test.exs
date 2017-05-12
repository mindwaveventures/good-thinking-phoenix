defmodule App.HomepageControllerTest do
  use App.ConnCase, async: false

  alias Plug.Conn
  alias App.Likes

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "<!DOCTYPE html>"
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, homepage_path(conn, :index)
    assert html_response(conn, 200) =~ "sleep issues"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    params = %{"audience" => %{"audience" => "false"},
               "category" => %{"category" => "not_found"},
               "content" => %{"content" => "false"}}
    conn = post conn, homepage_path(conn, :show, params)
    assert html_response(conn, 404)
  end

  test "categories for insomnia", %{conn: conn} do
    params = %{"audience" => %{"audience" => "false"},
               "category" => %{"category" => "insomnia"},
               "content" => %{"content" => "false"}}
    conn = post conn, homepage_path(conn, :show, params)
    assert html_response(conn, 200)
  end

  test "submit_email of email address", %{conn: conn} do
    params = %{"email" => %{"email" => "test@me.com"}}
    conn = post conn, homepage_path(conn, :submit_email, params)
    assert html_response(conn, 302)
  end

  test "submit_email of suggestions", %{conn: conn} do
    params = %{"suggestions" => %{"suggestions" => "suggestions"}}
    conn = post conn, homepage_path(conn, :submit_email, params)
    assert html_response(conn, 302)
  end

  @article_id "9"
  test "POST /like/#{@article_id} - existing article", %{conn: conn} do
    conn = 
      conn
        |> Conn.put_resp_cookie("_app_key", String.duplicate("asdf", 8))
        |> post(homepage_path(conn, :like, @article_id))

    %Likes{like_value: like_value} = Repo.get_by Likes, article_id: @article_id

    assert like_value == 1
    assert get_flash(conn, :info) == "Liked!"
    assert redirected_to(conn) == "/"
  end

  @article_id "9"
  test "POST /dislike/#{@article_id} - existing article", %{conn: conn} do
    conn = 
      conn
        |> Conn.put_resp_cookie("_app_key", String.duplicate("asdf", 8))
        |> post(homepage_path(conn, :dislike, @article_id))

    %Likes{like_value: like_value} = Repo.get_by Likes, article_id: @article_id

    assert like_value == -1
    assert get_flash(conn, :info) == "Disliked!"
    assert redirected_to(conn) == "/"
  end

  @article_id "9"
  test "multiple likes for an article", %{conn: conn} do
    conn
      |> Conn.put_resp_cookie("_app_key", String.duplicate("asdf", 8))
      |> post(homepage_path(conn, :like, @article_id))

    conn = 
      conn
        |> Conn.put_resp_cookie("_app_key", String.duplicate("asdf", 8))
        |> post(homepage_path(conn, :dislike, @article_id))

    %Likes{like_value: like_value} = Repo.get_by Likes, article_id: @article_id

    assert like_value == -1
    assert get_flash(conn, :info) == "Disliked!"
    assert redirected_to(conn) == "/"
  end
end
