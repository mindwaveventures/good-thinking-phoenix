defmodule App.SpreadsheetController do
  use App.Web, :controller

  @http Application.get_env :app, :http
  @google_sheet_url_email Application.get_env :app, :google_sheet_url_email
  @google_sheet_url_suggestion Application.get_env(
    :app, :google_sheet_url_suggestion)

  def submit_email(conn, %{"suggestions" => %{"suggestions" => suggestions}}) do
    handle_email conn, :suggestions, suggestions, @google_sheet_url_suggestion
  end

  def submit_email(conn, %{"email" => %{"email" => email}}) do
    handle_email conn, :email, email, @google_sheet_url_email
  end

  defp handle_email(conn, type, data, url) do
    @http.post_spreadsheet data, url, type

    message = case type do
      :email -> "Email address entered successfully!"
      :suggestions -> "Thank you for your input, it will be used to improve and develop the service further. Let us know if you have any more feedback"
    end

    conn
      |> put_flash(type, message)
      |> redirect(to: homepage_path(conn, :index))
  end
end
