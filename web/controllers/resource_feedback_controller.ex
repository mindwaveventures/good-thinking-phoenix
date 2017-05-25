defmodule App.ResourceFeedbackController do
  use App.Web, :controller
  import App.SpreadsheetController, only: [submit: 2]

  def resource_feedback(conn, params) do
    %{"resource_feedback" => feedback} = params

    conn
    |> submit(%{"resource_feedback" => Map.put(feedback, "id", params["id"])})
  end
end
