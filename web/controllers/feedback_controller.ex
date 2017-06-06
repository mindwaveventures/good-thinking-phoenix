defmodule App.FeedbackController do
  use App.Web, :controller
  alias App.CMSRepo
  alias App.Resources, as: R
  alias App.SpreadsheetController, as: S

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

    feedback_content_query = from page in "feedback_feedbackpage",
      select: %{form_title: page.form_title,
                feedback1: %{help_text: page.feedback1_help_text,
                             default_text: page.feedback1_default_text,
                             intro: page.feedback1_intro},
                feedback2: %{help_text: page.feedback2_help_text,
                             default_text: page.feedback2_default_text,
                             intro: page.feedback2_intro}}
    feedback_content = CMSRepo.one(feedback_content_query)

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

  def post(conn, params),
    do: S.submit conn, params, feedback_path(conn, :index) <> "#alphasection"
end
