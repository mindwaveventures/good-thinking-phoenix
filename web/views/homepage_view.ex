defmodule App.HomepageView do
  @moduledoc false
  use App.Web, :view

  def number_of_results(conn, resources) when length(resources) == 1, do: "1 #{result_or_resource(conn)}"
  def number_of_results(conn, resources), do: "#{length resources} #{result_or_resource(conn)}s"

  def result_or_resource(conn) do
    case conn.request_path do
      "/filter" -> "result"
      _ -> "resource"
    end
  end

  def check_liked("dislike", -1), do: "disliked"
  def check_liked("like", 1), do: "liked"
  def check_liked(class, _), do: class

  def tag_is_selected(selected_tags, tag) when is_list selected_tags do
    tag in selected_tags
  end
  def tag_is_selected(_, _), do: false

  @doc """
    ## nothing_selected
    ## returns true when tags are empty, or equal to type

    iex> nothing_selected("", "all-issue")
    true
    iex> nothing_selected("all-issue", "all-issue")
    true
    iex> nothing_selected("all-issue,insomnia", "all-issue")
    false
  """

  def nothing_selected(tags, type) when tags in ["", nil, type], do: true
  def nothing_selected(_, _), do: false

  @doc """
    iex> safe_to_atom("hi’hi")
    :"hi'hi"
    iex> safe_to_atom("hello")
    :"hello"
  """
  def safe_to_atom(string) do
    string
    |> String.replace("’", "'")
    |> String.to_charlist
    |> Enum.filter(&(&1 <= 255))
    |> to_string
    |> String.to_atom
  end

  def get_topic(%{query_string: query_string}) do
    query_string
    |> URI.decode_query
    |> Map.get("topic", nil)
    |> case do
      nil -> nil
      topic -> String.to_atom topic
    end
  end
end
