defmodule App.StyleGuideView do
  @moduledoc false
  use App.Web, :view

  @doc """
  ## Get a list of file names and filter it for those containing the word 'example'
    iex> App.StyleGuideView.get_example_files("./test/support/example_components")
  def render_whole_component(file_path) do
    category = get_category(file_path)
    component_eg = render_example_components(file_path)
    component_code = components_to_code(file_path)

    List.zip([category, component_eg, component_code])
  end
    ["primary_button_test_example.html.eex",
    "secondary_button_test_example.html.eex"]
    iex> App.StyleGuideView.get_example_files("./test/support/")
    ["example_components"]
    iex> App.StyleGuideView.get_example_files("./test/controllers")
    []
  """

# Matches all files that are in a sub-folder with the word example in.
  def get_example_files(file_path) do
    file_path
    |> Path.wildcard("#{file_path}/**/*example.html.eex")
    # Previous Code...
    # |> File.ls
    # |> elem(1)
    # |> Enum.filter(&(String.contains?(&1, "example")))
  end

  @doc """
  ## Map over the list of example files to remove .eex so it can be rendered inside another .eex file
    iex> App.StyleGuideView.render_example_components("./test/support/example_components")
    ["primary_button_test_example.html",
    "secondary_button_test_example.html"]
    iex> App.StyleGuideView.get_example_files("./test/controllers")
    []
  """

  def render_example_components(file_path) do
    file_path
    |> get_example_files
    |> remove_folder
    #  leave file name with no '.eex'
    |> Enum.map(&(String.trim_trailing(&1, ".eex")))
  end

  @doc """
  ## Display the Code of each Component
    iex> App.StyleGuideView.components_to_code("./test/support/example_components")
    [~s(<%= component "primary_button", value: "I'm a Primary Button" %>\\n),
    ~s(<%= component "secondary_button", value: "I'm a Secondary Button" %>\\n)]
    iex> App.StyleGuideView.components_to_code("./test/controllers")
    []
  """

  def components_to_code(file_path) do
    file_path
    |> get_example_files
    |> remove_folder
    |> Enum.map(&(File.read!("#{file_path}/#{&1}")))
  end

  def get_category(file_path) do
    # Trim file path to get category folder
    file_path
    |> get_example_files
    |> Enum.at(file_path, -2)
  end

  def remove_folder(file_path) do
    # Now need to remove excess file path to get old formula
    file_path
    |> String.split(file_path, ~r{/} )
    |> Enum.at(file_path, -1)
  end

  @doc """
  ## Render both the component and its code
  iex> App.StyleGuideView.render_whole_component("./test/support/example_components")
  [{"primary_button_test_example.html", ~s(<%= component "primary_button", value: "I'm a Primary Button" %>\\n)},
  {"secondary_button_test_example.html", ~s(<%= component "secondary_button", value: "I'm a Secondary Button" %>\\n)}]
  iex> App.StyleGuideView.components_to_code("./test/controllers")
  []
  """

  def render_whole_component(file_path) do
    category = get_category(file_path)
    component_eg = render_example_components(file_path)
    component_code = components_to_code(file_path)

    List.zip([category, component_eg, component_code])
  end

end
