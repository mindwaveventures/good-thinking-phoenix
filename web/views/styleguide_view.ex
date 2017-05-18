defmodule App.StyleGuideView do
  @moduledoc false
  use App.Web, :view

  @doc """
  ## Render both the component and its code
  iex> render_whole_component("./test/support/example_components")
  [{"buttons", "buttons/primary_button_test_example.html", ~s(<%= component "buttons/primary_button", value: "I'm a Primary Button" %>\\n)},
  {"links", "links/secondary_button_test_example.html", ~s(<%= component "links/secondary_button", value: "I'm a Secondary Button" %>\\n)}]
  iex> render_whole_component("./test/controllers")
  []
  """

  def render_whole_component(file_path) do
  end

  @doc """
  ## Trim file path to get only the category folder
  iex> get_category("./test/support/example_components")
  ["buttons", "links"]
  iex> get_category("./test/controllers")
  []
  """

  def get_category(file_path) do
    file_path
    |> get_example_full_path
    |> Enum.map(&(String.split(&1, ~r{/})))
    |> Enum.map(&(Enum.at(&1, -2)))
    |> Enum.map(&(String.capitalize(&1)))
  end

  @doc """
  ## Gets the full file path for any files containing the word 'example' within any
  ## folder in the specified pathway
    iex> get_example_full_path("./test/support/example_components")
    ["test/support/example_components/buttons/primary_button_test_example.html.eex",
    "test/support/example_components/links/secondary_button_test_example.html.eex"]
    iex> get_example_full_path("./test/support/")
    ["test/support/example_components/buttons/primary_button_test_example.html.eex",
    "test/support/example_components/links/secondary_button_test_example.html.eex"]
    iex> get_example_full_path("./test/controllers")
    []
  """

  def get_example_full_path(file_path) do
    Path.wildcard("#{file_path}/**/*example.html.eex")
  end

  def get_component_names(category_file_path) do
    category_file_path
    |> File.ls!
    |> Enum.filter(&(String.contains?(&1, "_example.html.eex")))
    |> Enum.map(&(String.trim_trailing(&1, "_example.html.eex")))
  end

end
