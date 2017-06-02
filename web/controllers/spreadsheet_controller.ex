defmodule App.SpreadsheetController do
  use App.Web, :controller
  alias App.{Feedback, Resources, HomepageView}
  import Phoenix.View, only: [render_to_string: 3]

  @http Application.get_env :app, :http
  @like_map %{"1" => "Like", "-1" => "Dislike"}

  def submit(conn, params),
    do: submit conn, params, homepage_path(conn, :index)
  def submit(conn, %{"suggestions" => %{"suggestions" => suggestions}}, path),
    do: handle_submit conn, :suggestions, [suggestions], path
  def submit(conn, %{"email" => %{"email" => email}}, path),
    do: handle_submit conn, :emails, [email], path
  def submit(conn, %{"feedback" => %{"email" => email,
                                     "question1" => question1,
                                     "feedback1" => feedback1,
                                     "feedback2" => feedback2}}, path) do
    input_list = [question1, feedback1, feedback2, email]
    handle_submit conn, :feedback, input_list, path
  end
  def submit(conn, %{"tag_suggestion" => tag_suggestion}, path),
    do: handle_submit conn, :tag_suggestion, tag_suggestion, path
  def submit(conn, %{"resource_feedback" => %{"id" => id,
                                              "liked" => liked,
                                              "resource_name" => name,
                                              "feedback" => feedback}}, path) do

    feedback_atom = String.to_atom "resource_feedback_#{id}"

    conn
    |> handle_submit(:resource_feedback, [id, name, @like_map[liked], feedback])
    |> put_flash(feedback_atom, "Thank you for your feedback")
    |> redirect_after_feedback(id, path)
  end
  def handle_submit(conn, tab_name, list, path) when is_list(list),
    do: conn |> handle_submit(tab_name, list) |> redirect(to: path)
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

  def redirect_after_feedback(conn, id, path) do
    case get_req_header conn, "accept" do
      ["application/json"] ->
        resource = Resources.get_single_resource conn, id
        result = render_to_string HomepageView, "resource.html",
                                  resource: resource, conn: conn
        json conn, %{result: result, id: id}
      _ ->
        redirect(conn, to: path)
    end
  end
end
