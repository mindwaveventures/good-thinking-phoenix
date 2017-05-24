defmodule App.ResourceFeedbackControllerTest do
  use App.ConnCase

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
end
