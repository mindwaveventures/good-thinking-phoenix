defmodule App.FeedbackController do
  use App.Web, :controller
  alias App.CMSRepo
  alias App.Resources, as: R

  def index(conn, params) do
    changes = Map.get(params, "changes", %{})
    form_content = [:help_text, :choices, :default_value,
                    :required, :field_type, :label]
    forms =
      "feedback_formfield"
      |> select([page], map(page, ^form_content))
      |> order_by([page], page.sort_order)
      |> CMSRepo.all

    feedback_content =
      [:help_text, :default_text, :intro]
      |> List.duplicate(2)
      |> Enum.with_index(1) # index starts at 1
      |> Enum.map(fn {content, i} ->
        Enum.map(content, &(String.to_atom "feedback#{i}_#{&1}")) end)
      |> List.flatten
      |> Enum.into([:form_title])

    feedback =
      "feedback_feedbackpage"
      |> select([page], ^feedback_content)
      |> CMSRepo.one

    content =
      [footer: "home", alpha: "feedback", alphatext: "feedback"]
      |> Map.new(fn {k, v} -> {k, R.get_content(k, v)} end)
    assigns =
      feedback
      |> Map.merge(%{content: content, forms: forms, changes: changes})
    render conn, "index.html", assigns
  end
end
