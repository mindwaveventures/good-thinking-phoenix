defmodule App.StyleGuideView do
  @moduledoc false
  use App.Web, :view

  @doc """
  ## Render all standard components with categories and code
  iex> render_whole_component("./test/support/example_components")
  [{"buttons",
    [{"duplicate",
      {"buttons/duplicate_example.html",
       ~s(<%= component "buttons/primary_button", value: "I'm a duplicate" %>\n)}},
     {"primary button",
      {"buttons/primary_button_example.html",
       ~s(<%= component "buttons/primary_button", value: "I'm a Primary Button" %>\n)}}]},
   {"links",
    [{"secondary button",
      {"links/secondary_button_example.html",
       ~s(<%= component "links/secondary_button", value: "I'm a Secondary Button" %>\n)}}]}]
  iex> render_whole_component("./test/controllers")
  []
  """

  def render_whole_component(file_path) do
    file_path
    |> get_category_list
    |> Enum.map(fn category -> get_category_components(file_path, category) end)
  end

  @doc """
  ## Get the components of a specified category
  iex> get_category_components("./test/support/example_components", "buttons")
  {"buttons",
   [{"duplicate",
     {"buttons/duplicate_example.html",
      ~s(<%= component "buttons/primary_button", value: "I'm a duplicate" %>\n)}},
    {"primary button",
     {"buttons/primary_button_example.html",
      ~s(<%= component "buttons/primary_button", value: "I'm a Primary Button" %>\n)}}]}
  """

  def get_category_components(file_path, category) do
      category_components =
        "#{file_path}/#{category}"
        |> get_component_names
        |> Enum.map(fn component_name ->
           get_component_details(file_path, category, component_name)
        end)

      {category, category_components}
  end

  @doc """
  ## Get the details of a given component
  ## (file name to render and code inside the file)
  iex> get_component_details("./test/support/example_components", "buttons", "primary_button")
  {"primary button",
   {"buttons/primary_button_example.html",
    ~s(<%= component "buttons/primary_button", value: "I'm a Primary Button" %>\n)}}
  """

  def get_component_details(file_path, category, component) do
    formatted_component = String.replace(component, "_", " ")

    {formatted_component, {
      "#{category}/#{component}_example.html",
      File.read!("#{file_path}/#{category}/#{component}_example.html.eex")
    }}
  end

  @doc """
  ## Search all example files and compile a list of all of their categories
  ## Removing any duplicated category names
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

  @doc """
  ## Search for all files with example in in the category file path
  ## Then remove the tail so you're left with the component name only
  iex> get_component_names("./test/support/example_components/buttons")
  ["duplicate", "primary_button"]
  iex> get_component_names("./test/controllers")
  []
  """

  def get_component_names(category_file_path) do
    category_file_path
    |> File.ls!
    |> Enum.filter(&(String.contains?(&1, "_example.html.eex")))
    |> Enum.map(&(String.trim_trailing(&1, "_example.html.eex")))
  end

end
