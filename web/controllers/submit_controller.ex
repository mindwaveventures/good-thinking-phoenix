defmodule App.SubmitController do
  use App.Web, :controller
  alias App.{Resources, HomepageView}
  import Phoenix.View, only: [render_to_string: 3]
  import App.SpreadsheetController, only: [handle_submit: 3]

  @like_map %{"1" => "Like", "-1" => "Dislike"}

  def submit(conn, %{"suggestions" => %{"suggestions" => suggestions}}) do
    conn
    |> handle_submit(:suggestions, [suggestions])
    |> redirect(to: homepage_path(conn, :index) <> "#suggestion_form")
  end
  def submit(conn, %{"email" => %{"email" => email}}) do
    conn
    |> handle_submit(:emails, [email])
    |> redirect(to: homepage_path(conn, :index) <> "#alphasection")
  end
  def submit(conn, %{"feedback" => feedback}) do
    input_list = Enum.map ["email", "feedback1", "feedback2"], &(feedback[&1])
    question1 = Map.get feedback, "question1", ""
    input_list = input_list ++ [question1]

    conn
    |> handle_submit(:feedback, input_list)
    |> redirect(to: feedback_path(conn, :index, %{changes: feedback}) <> "#alphasection")
  end
  def submit(conn, %{"tag_suggestion" => tag_suggestion}),
    do: handle_submit conn, :tag_suggestion, tag_suggestion
  def submit(conn, %{"resource_feedback" => %{
    "liked" => liked, "resource_name" => name, "feedback" => feedback,
    "id" => id}}) do
    feedback
    |> case do
      "" ->
        flash = {id, "Please submit some feedback"}
        conn
          |> put_flash(:resource_feedback_error, flash)
      _ ->
        input_data = [id, name, @like_map[liked], feedback]
        flash = {id, "Thank you for your feedback"}
        conn
          |> handle_submit(:resource_feedback, input_data)
          |> put_flash(:resource_feedback, flash)
    end
    |> redirect_after_feedback(id)
  end

  def redirect_after_feedback(conn, id) do
    case get_req_header conn, "accept" do
      ["application/json"] ->
        resource = Resources.get_single_resource conn, id
        result = render_to_string HomepageView, "resource.html",
                                  resource: resource, conn: conn
        json conn, %{result: result, id: id}
      _ ->
        redirect conn, to: homepage_path(conn, :show)
    end
  end
end
