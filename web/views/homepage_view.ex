defmodule App.HomepageView do
  use App.Web, :view

  def number_of_results (resources) do
    case n = length(resources) do
      1 -> "1 result"
      _ -> "#{n} results"
    end
  end
end
