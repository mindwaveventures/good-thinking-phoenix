defmodule App.StyleGuideView do
  @moduledoc false
  use App.Web, :view

  @doc """
  ## Get Example Files

    iex> App.StyleGuideView.get_example_files("./test/views/example_components")
    ["primary_button_test_example.html.eex",
    "secondary_button_test_example.html.eex"]
    iex> App.StyleGuideView.get_example_files("./test/views/")
    ["example_components"]
    iex> App.StyleGuideView.get_example_files("./test/controllers")
    []

  """

  def get_example_files(file_path) do
    # Get a list of file names and filter it for those containing the word 'example'
    elem(File.ls(file_path), 1)
    |> Enum.filter(fn file ->
      String.contains?( file, "example")
    end)
  end

  def render_example_components(file_path) do
    # Map over the list to remove .eex so it can be rendered inside another .eex file
    get_example_files(file_path)
    |> Enum.map(fn file ->
      String.trim_trailing(file, ".eex")
    end)
  end

  def components_to_code(file_path) do
    # Display the code of each component
    get_example_files(file_path)
    |> Enum.map(fn file ->
      File.read!("#{file_path}/#{file}")
    end)
  end

  def render_whole_component(file_path) do
    component_eg = render_example_components(file_path)
    component_code = components_to_code(file_path)
    tuple_of_lists = [component_eg, component_code]
    List.zip([component_eg, component_code])
  end

end
