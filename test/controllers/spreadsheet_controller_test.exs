defmodule App.SpreadsheetControllerTest do
  use App.ConnCase, async: false
  doctest App.SpreadsheetController, import: true

  test "submit of feedback", %{conn: conn} do
    [%{"email" => %{"email" => "test@me.com"}},
     %{"suggestions" => %{"suggestions" => "suggestions"}},
     %{"feedback" => %{"email" => "email@me.com",
                       "question1" => "question",
                       "feedback1" => "feedback1",
                       "feedback2" => "feedback2"}}]
    |> Enum.each(fn params ->
      conn = post conn, feedback_path(conn, :post, params)
      assert html_response(conn, 302)
    end)
  end

  test "submit empty string", %{conn: conn} do
    params = %{"suggestions" => %{"suggestions" => ""}}
    conn = post conn, feedback_path(conn, :post, params)

    refute get_flash(conn, :suggestions)
    assert get_flash(conn, :suggestions_error)
    assert html_response(conn, 302)
  end

  test "submit invalid email", %{conn: conn} do
    params = %{"email" => %{"email" => "fff"}}
    conn = post conn, feedback_path(conn, :post, params)

    assert get_flash(conn, :emails_error)
    assert html_response(conn, 302)
  end
end
