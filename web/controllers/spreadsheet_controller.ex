defmodule App.SpreadsheetController do
  use App.Web, :controller
  @http Application.get_env :app, :http

  def submit(conn, %{"suggestions" => %{"suggestions" => suggestions}}) do
    handle_submit conn, :suggestions, [suggestions]
  end

  def submit(conn, %{"email" => %{"email" => email}}) do
    handle_submit conn, :emails, [email]
  end

  def submit(conn, %{"feedback" => %{"question" => question,
                                     "feedback1" => feedback1,
                                     "feedback2" => feedback2}}) do
    handle_submit conn, :feedback, [question, feedback1, feedback2]
  end

  defp handle_submit(conn, tab_name, data_list) do
    @http.post_spreadsheet data_list, tab_name

    message = case tab_name do
      :emails -> "Email address entered successfully!"
      :suggestions -> "Thank you for your input, it will "
                   <> "be used to improve and develop the service further. "
                   <> "Let us know if you have any more feedback"
      :feedback -> "Thanks for your feedback"
    end

    conn
      |> put_flash(tab_name, message)
      |> redirect(to: homepage_path(conn, :index))
  end
end
