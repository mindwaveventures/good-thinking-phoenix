defmodule App.SpreadsheetControllerTest do
  use App.ConnCase, async: false

  test "submit_email of email address", %{conn: conn} do
    params = %{"email" => %{"email" => "test@me.com"}}
    conn = post conn, spreadsheet_path(conn, :submit_email, params)
    assert html_response(conn, 302)
  end

  test "submit_email of suggestions", %{conn: conn} do
    params = %{"suggestions" => %{"suggestions" => "suggestions"}}
    conn = post conn, spreadsheet_path(conn, :submit_email, params)
    assert html_response(conn, 302)
  end
end
