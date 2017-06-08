defmodule App.ResourceFeedbackController do
  use App.Web, :controller
  import App.SpreadsheetController, only: [submit: 2,
                                           redirect_after_feedback: 2]

  def resource_feedback(conn, %{"resource_feedback" => feedback} = params) do
    conn
    |> submit(%{"resource_feedback" => Map.put(feedback, "id", params["id"])})
    |> redirect_after_feedback(params["id"])
    |> handle_json_redirect(params)
  end

  def handle_json_redirect(conn, params) do
    case get_req_header(conn, "accept") do
      ["application/json"] -> conn
      _ -> redirect conn, to: homepage_path(conn, :show)
    end
  end
end
