defmodule App.SpreadsheetController do
  use App.Web, :controller
  alias App.{Feedback, Resources, HomepageView}
  import Phoenix.View, only: [render_to_string: 3]

  @http Application.get_env :app, :http
  @like_map %{"1" => "Like", "-1" => "Dislike"}
  @feedback_map %{
    success: %{
      emails: "Email address entered successfully!",
      suggestions: "Thank you for your input, it will "
                   <> "be used to improve and develop the service further. "
                   <> "Let us know if you have any more feedback",
      feedback: "Thanks for your feedback",
      tag_suggestion: "Thank you for your suggestion"
    },
    error: %{
      emails: "Please enter a valid email address",
      suggestions: "Please enter a suggestion",
      feedback: "Please ensure you have filled in some of the fields",
      tag_suggestion: "Please fill in a suggestion"
    }
  }

  def submit(conn, %{"suggestions" => %{"suggestions" => suggestions}}),
    do: handle_submit conn, :suggestions, [suggestions]
  def submit(conn, %{"email" => %{"email" => email}}),
    do: handle_submit conn, :emails, [email]
  def submit(conn, %{"feedback" => feedback}) do
    input_list = Enum.map ["email", "feedback1", "feedback2"], &(feedback[&1])
    question1 = Map.get feedback, "question1", ""
    input_list = [question1] ++ input_list
    handle_submit conn, :feedback, input_list
  end
  def submit(conn, %{"tag_suggestion" => tag_suggestion}),
    do: handle_submit conn, :tag_suggestion, tag_suggestion
  def submit(conn, %{"resource_feedback" => %{"id" => id,
                                              "liked" => liked,
                                              "resource_name" => name,
                                              "feedback" => feedback}}) do

    case feedback do
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
  end
  def handle_submit(conn, tab_name, data_list) when is_list(data_list) do
    case @feedback_map
          |> Map.values
          |> Enum.map(&Map.has_key?(&1, tab_name))
          |> Enum.all?(&(&1)) do
      false -> conn
      true ->
        case valid_feedback(tab_name, data_list) do
          "invalid_email" ->
            flash_name = tab_name
                           |> Atom.to_string
                           |> Kernel.<>("_error")
                           |> String.to_atom
            put_flash conn, flash_name, @feedback_map.error[:emails]
          false ->
            flash_name = tab_name
                           |> Atom.to_string
                           |> Kernel.<>("_error")
                           |> String.to_atom
            put_flash conn, flash_name, @feedback_map.error[tab_name]
          true ->
            store_data conn, data_list, tab_name
            @http.post_spreadsheet data_list, tab_name
            put_flash conn, tab_name, @feedback_map.success[tab_name]
        end
    end
  end

  @email_tabs [{:emails, 0}, {:feedback, 3}]
  @doc """
    iex> email_validation?(:emails, ["ffff"])
    false
    iex> email_validation?(:emails, ["user@test.com"])
    true
    iex> email_validation?(:feedback, ["", "ffff", "", ""])
    false
    iex> email_validation?(:feedback, ["", "user@test.com", "", ""])
    true
    iex> email_validation?(:feedback, ["Data", "", "", ""])
    true
  """
  def email_validation?(:emails, data_list),
    do: data_list |> Enum.fetch!(0) |> email_validation?

  def email_validation?(:feedback, data_list) do
    index = if length(data_list) == 4 do 1 else 0 end
    feedback_email = Enum.fetch! data_list, index
    case feedback_email == "" do
      true -> true
      false -> email_validation? feedback_email
    end
  end

  defp email_validation?(email),
    do: String.contains?(email, "@") and String.contains?(email, ".")

  defp handle_email_validation(tab_name, data_list) do
    case tab_name in Enum.map(@email_tabs, &elem(&1, 0)) do
      false -> true
      true -> email_validation?(tab_name, data_list) or "invalid_email"
    end
  end

  defp valid_feedback(tab_name, data_list) do
    case Enum.join(data_list) == "" do
      true -> false
      false -> handle_email_validation(tab_name, data_list)
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

  def redirect_after_feedback(conn, id) do
    case get_req_header conn, "accept" do
      ["application/json"] ->
        resource = Resources.get_single_resource conn, id
        result = render_to_string HomepageView, "resource.html",
                                  resource: resource, conn: conn
        json conn, %{result: result, id: id}
      _ ->
        conn
    end
  end
end
