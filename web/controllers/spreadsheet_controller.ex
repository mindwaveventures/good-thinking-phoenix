defmodule App.SpreadsheetController do
  use App.Web, :controller
  alias App.Feedback

  @http Application.get_env :app, :http

  def submit(conn, %{"suggestions" => %{"suggestions" => suggestions}}) do
    conn
    |> handle_submit(:suggestions, [suggestions])
    |> redirect(to: homepage_path(conn, :index))
  end

  def submit(conn, %{"email" => %{"email" => email}}) do
    conn
    |> handle_submit(:emails, [email])
    |> redirect(to: homepage_path(conn, :index))
  end

  def submit(conn, %{"feedback" => %{"email" => email,
                                     "question1" => question1,
                                     "feedback1" => feedback1,
                                     "feedback2" => feedback2}}) do
    conn
    |> handle_submit(:feedback, [question1, feedback1, feedback2, email])
    |> redirect(to: homepage_path(conn, :index))
  end

  def submit(conn, %{"tag_suggestion" => tag_suggestion}) do
    conn
    |> handle_submit(:tag_suggestion, tag_suggestion)
    |> redirect(to: homepage_path(conn, :index))
  end

  def submit(conn, %{"resource_feedback" => %{
    "id" => id,
    "liked" => liked,
    "resource_name" => name,
    "feedback" => feedback
  }}) do

    conn
    |> handle_submit(:resource_feedback, [
      id, name, "#{if liked == "1" do "Like" else "Dislike" end}", feedback
    ])
    |> put_flash(
      String.to_atom("resource_feedback_#{id}"), "Thank you for your feedback"
    )
    |> redirect(to: homepage_path(conn, :index))
  end

  defp handle_submit(conn, tab_name, data_list) do
    case Enum.join data_list do
      "" -> conn
      _ ->
        store_data conn, data_list, tab_name
        @http.post_spreadsheet data_list, tab_name

        message = case tab_name do
          :emails -> "Email address entered successfully!"
          :suggestions -> "Thank you for your input, it will "
                       <> "be used to improve and develop the service further. "
                       <> "Let us know if you have any more feedback"
          :feedback -> "Thanks for your feedback"
          :tag_suggestion -> "Thank you for your suggestion"
          _ -> nil
        end

        if message do
          conn
          |> put_flash(tab_name, message)
        else
          conn
        end
    end
  end

  def store_data(conn, data_list, tab_name) do
    lm_session = get_session(conn, :lm_session)
    %Feedback{}
    |> Feedback.changeset(%{user_hash: lm_session,
                            tab_name: "#{tab_name}",
                            data: data_list})
    |> Repo.insert!
  end
end
