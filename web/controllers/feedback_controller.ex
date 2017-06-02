defmodule App.FeedbackController do
  use App.Web, :controller
  alias App.CMSRepo
  alias App.Resources, as: R
  alias App.SpreadsheetController, as: S

  def index(conn, _params) do
    forms_query = from page in "feedback_formfield",
      select: %{question: page.help_text,
                choices: page.choices,
                default_value: page.default_value,
                required: page.required,
                field_type: page.field_type,
                label: page.label},
      order_by: page.sort_order
    forms = CMSRepo.all(forms_query)

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
                 forms: handle_bold(forms),
                 form_title: handle_bold(feedback_content.form_title),
                 feedback1: handle_bold(feedback_content.feedback1),
                 feedback2: handle_bold(feedback_content.feedback2),
                 content: %{footer: R.get_content(:footer),
                            alpha: R.get_content(:alpha,
                                                 {"/home/feedback/",
                                                  "feedback_feedbackpage"}),
                            alphatext: R.get_content(:alphatext,
                                                 {"/home/feedback/",
                                                  "feedback_feedbackpage"})}
  end

  def handle_bold(string) when is_binary(string),
    do: R.handle_bold(string)
  def handle_bold(map) when is_map(map),
    do: map |> Map.to_list |> Map.new(fn {k, v} -> {k, handle_bold(v)} end)
  def handle_bold(list) when is_list(list),
    do: Enum.map(list, &handle_bold/1)
  def handle_bold(bool) when is_boolean(bool),
    do: bool

  def post(conn, params),
    do: S.submit conn, params, feedback_path(conn, :index) <> "#alphasection"
end
