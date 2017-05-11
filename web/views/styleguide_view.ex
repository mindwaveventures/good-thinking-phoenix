defmodule App.StyleGuideView do
  use App.Web, :view

  defp get_example_components(file_path) do
    # Get a list of file names
    # Filter list for those that contain the word 'example'
    # Map over the list to remove .eex and then gets rendered in index.html.eex

    elem(File.ls(file_path), 1)
    |> Enum.filter(fn file ->
      String.contains?( file, "example")
    end)
  end

  defp render_example_components(file_path) do
    get_example_components(file_path)
    |> Enum.map(fn file ->
      String.trim_trailing(file, ".eex")
    end)
  end

  defp components_to_code(file_path) do
    get_example_components(file_path)
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
