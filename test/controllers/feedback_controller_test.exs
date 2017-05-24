defmodule App.FeedbackControllerTest do
  use App.ConnCase

  test "GET /feedback", %{conn: conn} do
    conn = get conn, "/feedback"
    assert html_response(conn, 200) =~ "<!DOCTYPE html>"
  end
end
