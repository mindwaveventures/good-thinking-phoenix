defmodule App.HomepageView do
  @moduledoc false
  use App.Web, :view

  @doc """
  ## Number of Results

    iex> App.HomepageView.number_of_results([])
    "0 results"
    iex> App.HomepageView.number_of_results(["one"])
    "1 result"
    iex> App.HomepageView.number_of_results(["one", "two"])
    "2 results"

  """

  def number_of_results(resources) when length(resources) == 1, do: "1 result"
  def number_of_results(resources), do: "#{length resources} results"

  def check_liked("dislike", -1), do: "disliked"
  def check_liked("like", 1), do: "liked"
  def check_liked(class, _), do: class
end
