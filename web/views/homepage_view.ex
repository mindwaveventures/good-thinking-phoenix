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

  def number_of_results(resources) do
    case n = length(resources) do
      1 -> "1 result"
      _ -> "#{n} results"
    end
  end
end
