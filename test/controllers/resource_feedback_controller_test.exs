defmodule App.ResourceFeedbackControllerTest do
  use App.ConnCase
  alias Plug.Conn

  test "submit resource feedback", %{conn: conn} do
    params = %{
      "id" => 5,
      "resource_feedback" => %{
        "liked" => "1",
        "resource_name" => "Sleepio",
        "feedback" => "Helped me to sleep"
      }
    }
    conn = post conn, "/resourcefeedback/1", params
    assert get_flash(conn, :resource_feedback_1) == "Thank you for your feedback"
    assert redirected_to(conn) == "/"
  end

  test "submit resource feedback - json", %{conn: conn} do
    params = %{
      "id" => 5,
      "resource_feedback" => %{
        "liked" => "1",
        "resource_name" => "Sleepio",
        "feedback" => "Helped me to sleep"
      }
    }
    conn =
      conn
      |> Conn.put_req_header("accept", "application/json")
      |> post("/resourcefeedback/29", params)

    assert get_flash(conn, :resource_feedback_29) == "Thank you for your feedback"
    assert json_response(conn, 200)
  end
end
