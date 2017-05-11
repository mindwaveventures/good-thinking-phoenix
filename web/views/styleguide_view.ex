defmodule App.StyleGuideView do
  use App.Web, :view

  defp render_example_components() do
    # Get a list of file names
    # Filter list for those that contain the word 'example'
    # Map over the list to remove .eex and then gets rendered in index.html.eex

    elem(File.ls("./web/templates/component"), 1)
    |> Enum.filter(fn file ->
      String.contains?( file, "example")
    end)
    |> Enum.map(fn file ->
      String.trim_trailing(file, ".eex")
    end)
  end

  defp components_to_code() do
    elem(File.ls("./web/templates/component"), 1)
    |> Enum.filter(fn file ->
      String.contains?( file, "example")
    end)
    |> Enum.map(fn file ->
      File.read!("./web/templates/component/#{file}")
    end)
  end
  def render_whole_component() do
    component_eg = render_example_components()
    component_code = components_to_code()
    tuple_of_lists = [component_eg, component_code]
    List.zip([component_eg, component_code])
  end

end
