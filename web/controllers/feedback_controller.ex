defmodule App.FeedbackController do
  use App.Web, :controller
  alias App.CMSRepo
  alias App.Resources, as: R
  alias App.SpreadsheetController, as: S

<<<<<<< HEAD
  defp handle_bold(elem) when not is_list(elem), do: R.handle_bold elem
  defp handle_bold(elem) when is_list(elem), do: Enum.map elem, &handle_bold/1
  def index(conn, _params) do
    form_content = [:help_text, :choices, :default_value,
                    :required, :field_type, :label]
    forms =
      "feedback_formfield"
      |> select([page], map(page, ^form_content))
      |> order_by([page], page.sort_order)
      |> CMSRepo.all
=======
  defp replace_key(map, key_old, key_new) when is_map(map) do
    Map.new(map, fn {k, v} ->
      if k == key_old do {key_new, v} else {k, v} end
    end)
  end

  def index(conn, _params) do
    form_content = [:help_text, :choices, :default_value,
                    :required, :field_type, :label]
    forms_query = from page in "feedback_formfield",
      select: map(page, ^form_content),
      order_by: page.sort_order
    forms = forms_query
      |> CMSRepo.all
      |> Enum.map(&(replace_key(&1, :help_text, :question)))
>>>>>>> making use of the new get_content function

    feedback_content =
      [:help_text, :default_text, :intro]
      |> List.duplicate(2)
      |> Enum.with_index(1) # index starts at 1
      |> Enum.map(fn {content, i} ->
        Enum.map(content, &(String.to_atom "feedback#{i}_#{&1}")) end)
      |> List.flatten
      |> Enum.into([:form_title])

<<<<<<< HEAD
    feedback =
      "feedback_feedbackpage"
      |> select([page], ^feedback_content)
      |> CMSRepo.one

    content =
      [footer: "home", alpha: "feedback", alphatext: "feedback"]
      |> Map.new(fn {k, v} -> {k, R.get_content(k, v)} end)
    assigns =
      feedback
      |> Map.merge(%{content: content, forms: forms})
      |> Map.new(fn {k, v} -> {k, handle_bold(v)} end)
    render conn, "index.html", assigns
  end

=======
    render conn, "index.html",
                 forms: Enum.map(forms, &R.handle_bold/1),
                 form_title: R.handle_bold(feedback_content.form_title),
                 feedback1: R.handle_bold(feedback_content.feedback1),
                 feedback2: R.handle_bold(feedback_content.feedback2),
                 content: %{footer: R.get_content(:footer),
                            alpha: R.get_content(:alpha,
                                                 {"/home/feedback/",
                                                  "feedback_feedbackpage"}),
                            alphatext: R.get_content(:alphatext,
                                                 {"/home/feedback/",
                                                  "feedback_feedbackpage"})}
  end

>>>>>>> get_content is now flexible and can take atoms and lists of atoms, also refactored the use of handle_bold in the feedback controller
  def post(conn, params),
    do: S.submit conn, params, feedback_path(conn, :index) <> "#alphasection"
end
