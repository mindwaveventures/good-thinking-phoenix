defmodule App.HomepageView do
  @moduledoc false
  use App.Web, :view

  @doc """
  ## Number of Results

    iex> number_of_results([])
    "0 results"
    iex> number_of_results(["one"])
    "1 result"
    iex> number_of_results(["one", "two"])
    "2 results"
  """

  def number_of_results(resources) when length(resources) == 1, do: "1 result"
  def number_of_results(resources), do: "#{length resources} results"

  def check_liked("dislike", -1), do: "disliked"
  def check_liked("like", 1), do: "liked"
  def check_liked(class, _), do: class

  def tag_is_selected(selected_tags, tag) when is_binary(selected_tags) do
    tag in String.split(selected_tags, ",")
  end
  def tag_is_selected(_, _), do: false

  @doc """
    ## nothing_selected
    ## returns true when tags are empty, or equal to type

    iex> nothing_selected("", "all-category")
    true
    iex> nothing_selected("all-category", "all-category")
    true
    iex> nothing_selected("all-category,insomnia", "all-category")
    false
  """

  def nothing_selected(tags, type) when tags in ["", nil, type], do: true
  def nothing_selected(_, _), do: false

  def remove_hyphen(str) do
    String.replace(str, "-", " ")
  end
end
