defmodule App.SpreadsheetController do
  use App.Web, :controller
  @http Application.get_env :app, :http

  def submit(conn, %{"suggestions" => %{"suggestions" => suggestions}}) do
    conn
    |>handle_submit(:suggestions, [suggestions])
    |> redirect(to: homepage_path(conn, :index))
  end

  def submit(conn, %{"email" => %{"email" => email}}) do
    conn
    |>handle_submit(:emails, [email])
    |> redirect(to: homepage_path(conn, :index))
  end

  def submit(conn, %{"feedback" => %{"question" => question,
                                     "feedback1" => feedback1,
                                     "feedback2" => feedback2}}) do
    conn
    |> handle_submit(:feedback, [question, feedback1, feedback2])
    |> redirect(to: homepage_path(conn, :index))
  end

  defp handle_submit(conn, tab_name, data_list) do
    case Enum.join data_list do
      "" -> conn
      _ ->
        @http.post_spreadsheet data_list, tab_name

        message = case tab_name do
          :emails -> "Email address entered successfully!"
          :suggestions -> "Thank you for your input, it will "
                       <> "be used to improve and develop the service further. "
                       <> "Let us know if you have any more feedback"
          :feedback -> "Thanks for your feedback"
          :tag_suggestion -> "Thank you for your suggestion"
        end

        conn
        |> put_flash(type, message)
    end
  end
end
