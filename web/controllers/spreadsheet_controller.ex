defmodule App.SpreadsheetController do
  use App.Web, :controller
  alias App.Feedback

  @http Application.get_env :app, :http
  @like_map %{"1" => "Like", "-1" => "Dislike"}

  def submit(conn, params),
    do: submit conn, params, homepage_path(conn, :index)
  def submit(conn, %{"suggestions" => %{"suggestions" => suggestions}}, path) do
    conn
    |> handle_submit(:suggestions, [suggestions])
    |> redirect(to: path)
  end
  def submit(conn, %{"email" => %{"email" => email}}, path) do
    conn
    |> handle_submit(:emails, [email])
    |> redirect(to: path)
  end
  def submit(conn, %{"feedback" => %{"email" => email,
                                     "question1" => question1,
                                     "feedback1" => feedback1,
                                     "feedback2" => feedback2}}, path) do
    conn
    |> handle_submit(:feedback, [question1, feedback1, feedback2, email])
    |> redirect(to: path)
  end
  def submit(conn, %{"tag_suggestion" => tag_suggestion}, path) do
    conn
    |> handle_submit(:tag_suggestion, tag_suggestion)
    |> redirect(to: path)
  end
  def submit(conn, %{"resource_feedback" => %{"id" => id,
                                              "liked" => liked,
                                              "resource_name" => name,
                                              "feedback" => feedback}}, path) do

    feedback_atom = String.to_atom "resource_feedback_#{id}"

    conn
    |> handle_submit(:resource_feedback, [id, name, @like_map[liked], feedback])
    |> put_flash(feedback_atom, "Thank you for your feedback")
    |> redirect(to: path)
  end
  defp handle_submit(conn, tab_name, data_list) do
    case Enum.join data_list do
      "" -> conn
      _ ->
        store_data conn, data_list, tab_name
        @http.post_spreadsheet data_list, tab_name

        feedback_map = %{
          emails: "Email address entered successfully!",
          suggestions: "Thank you for your input, it will "
                       <> "be used to improve and develop the service further. "
                       <> "Let us know if you have any more feedback",
          feedback: "Thanks for your feedback",
          tag_suggestion: "Thank you for your suggestion"
        }

        case feedback_map[tab_name] do
          nil -> conn
          message -> put_flash conn, tab_name, message
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
