defmodule App.SpreadsheetController do
  use App.Web, :controller
  alias App.Feedback

  @http Application.get_env :app, :http
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

  def handle_submit(conn, tab_name, data_list) when is_list(data_list) do
    case valid_feedback(tab_name, data_list) do
      {false, type} ->
        flash_name = tab_name
                       |> Atom.to_string
                       |> Kernel.<>("_error")
                       |> String.to_atom
        put_flash conn, flash_name, @feedback_map.error[type]
      {true, _type} ->
        store_data conn, data_list, tab_name
        @http.post_spreadsheet data_list, tab_name
        put_flash conn, tab_name, @feedback_map.success[tab_name]
    end
  end

  @email_tabs [{:emails, 0}, {:feedback, 3}]
  @doc """
    iex> email_validation?(["ffff"])
    false
    iex> email_validation?(["user@test.com"])
    true
    iex> email_validation?(["ffff", "ffff", "", ""])
    false
    iex> email_validation?(["", "user@test.com", "", ""])
    true
  """
  def email_validation?(data_list) do
    case List.first data_list do
      "" -> true
      email -> String.contains?(email, "@") and String.contains?(email, ".")
    end
  end

  defp is_email?(tab_name) do
    tab_name in Enum.map(@email_tabs, &elem(&1, 0))
  end

  defp valid_feedback(tab_name, data_list) do
    case Enum.join data_list do
      "" -> {false, tab_name}
      _ ->
        case is_email?(tab_name) do
          true -> {email_validation?(data_list), :emails}
          false -> {true, tab_name}
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
