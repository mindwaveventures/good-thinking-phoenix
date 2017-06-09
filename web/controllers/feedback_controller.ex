defmodule App.FeedbackController do
  use App.Web, :controller
  alias App.{CMSRepo, Feedback}
  alias App.Resources, as: R
  alias App.SpreadsheetController, as: S

  defp handle_bold(elem) when not is_list(elem), do: R.handle_bold elem
  defp handle_bold(elem) when is_list(elem), do: Enum.map elem, &handle_bold/1
  def index(conn, params = %{"changes" => changes}) do
    changeset = Feedback.changeset(%Feedback{}, changes || %{})
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
      |> Map.merge(%{content: content, forms: forms, changeset: changeset})
    render conn, "index.html", assigns
  end

  def post(conn, %{"feedback" => feedback} = params) do
    changeset = Feedback.changeset(%Feedback{}, %{data: Enum.map(feedback, fn {name, feedback} -> feedback end)})
    conn
    |> S.submit(params)
    |> redirect(to: feedback_path(conn, :index, %{changes: changeset.changes}) <> "#alphasection")
  end
end
