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
    file_path
    |> get_category_list
    |> Enum.map(fn category -> get_category_components(file_path, category) end)
  end

  def get_category_components(file_path, category) do
      category_components =
        "#{file_path}/#{category}"
        |> get_component_names
        |> Enum.map(fn component_name -> get_component_details(file_path, category, component_name) end)

      {category, category_components}
  end

  def get_component_details(file_path, category, component) do
    {"#{category}/#{component}_example.html",
      File.read!("#{file_path}/#{category}/#{component}_example.html.eex")}
  end

  @doc """
  ## Trim file path to get only the category folder
  iex> get_category_list("./test/support/example_components")
  ["buttons", "links"]
  iex> get_category_list("./test/controllers")
  []
  """

  def get_category_list(file_path) do
    "#{file_path}/**/*example.html.eex"
    |> Path.wildcard
    |> Enum.map(&(String.split(&1, ~r{/})))
    |> Enum.map(&(Enum.at(&1, -2)))
    |> Enum.uniq
  end

  def get_component_names(category_file_path) do
    category_file_path
    |> File.ls!
    |> Enum.filter(&(String.contains?(&1, "_example.html.eex")))
    |> Enum.map(&(String.trim_trailing(&1, "_example.html.eex")))
  end

end
