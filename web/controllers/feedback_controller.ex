defmodule App.FeedbackController do
  use App.Web, :controller
  alias App.CMSRepo
  alias App.Resources, as: R

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

    render conn, "index.html", forms: forms,
                               feedback1: feedback_content.feedback1,
                               feedback2: feedback_content.feedback2,
                               content: %{alphatext: R.get_content(:alphatext),
                                          footer: R.get_content(:footer)}
  end

  def post(conn, params) do
    IO.inspect params
    conn
  end
end
