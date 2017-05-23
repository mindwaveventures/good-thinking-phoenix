defmodule App.SpreadsheetControllerTest do
  use App.ConnCase, async: false

  test "submit of feedback", %{conn: conn} do
    [%{"email" => %{"email" => "test@me.com"}},
     %{"suggestions" => %{"suggestions" => "suggestions"}},
     %{"feedback" => %{"question" => "question",
                       "feedback1" => "feedback1",
                       "feedback2" => "feedback2"}}]
    |> Enum.each(fn params ->
      conn = post conn, spreadsheet_path(conn, :submit, params)
      assert html_response(conn, 302)
    end)
  end
end
