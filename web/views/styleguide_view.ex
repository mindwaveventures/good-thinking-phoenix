defmodule App.StyleGuideView do
  @moduledoc false
  use App.Web, :view

  @doc """
  ## Render both the component and its code
  iex> render_whole_component("./test/support/example_components")
  [{"Buttons", "Buttons/primary_button_test_example.html", ~s(<%= component "Buttons/primary_button", value: "I'm a Primary Button" %>\\n)},
  {"Links", "Links/secondary_button_test_example.html", ~s(<%= component "Links/secondary_button", value: "I'm a Secondary Button" %>\\n)}]
  iex> components_to_code("./test/controllers")
  []
  """

  def render_whole_component(file_path) do
    category = get_category(file_path)
    component_eg = render_example_components(file_path)
    component_code = components_to_code(file_path)

    List.zip([category, component_eg, component_code])
  end

  @doc """
  ## Trim file path to get only the category folder
  iex> get_category("./test/support/example_components")
  ["Buttons", "Links"]
  iex> get_category("./test/controllers")
  []
  """

  def get_category(file_path) do
    file_path
    |> get_example_full_path
    |> Enum.map(&(String.split(&1, ~r{/})))
    |> Enum.map(&(Enum.at(&1, -2)))
  end

  @doc """
  ## Gets the full file path for any files containing the word 'example' within any
  ## folder in the specified pathway
    iex> get_example_full_path("./test/support/example_components")
    ["test/support/example_components/Buttons/primary_button_test_example.html.eex",
    "test/support/example_components/Links/secondary_button_test_example.html.eex"]
    iex> get_example_full_path("./test/support/")
    ["test/support/example_components/Buttons/primary_button_test_example.html.eex",
    "test/support/example_components/Links/secondary_button_test_example.html.eex"]
    iex> get_example_full_path("./test/controllers")
    []
  """

  def get_example_full_path(file_path) do
    Path.wildcard("#{file_path}/**/*example.html.eex")
  end

  @doc """
  ## Remove the unneeded pathway beginning leaving just the category and file name
  ## Remove the unwanted '.eex' so the files are ready to be rendered
    iex> render_example_components("./test/support/example_components")
    ["Buttons/primary_button_test_example.html",
    "Links/secondary_button_test_example.html"]
    iex> get_example_full_path("./test/controllers")
    []
  """

  def render_example_components(file_path) do
    file_path
    |> get_example_full_path
    |> Enum.map(&(get_category_and_file(&1)))
    |> Enum.map(&(String.trim_trailing(&1, ".eex")))
  end

  @doc """
  ## Remove the initial file path to leave just the category and file name
    iex> get_category_and_file("./test/support/example_components/Buttons")
    "example_components/Buttons"
    iex> get_category_and_file("./test/controllers")
    "controllers"
  """

  def get_category_and_file(file_path) do
    file_path
    |> String.split(~r{/}, parts: 4)
    |> Enum.at(-1)
  end

  @doc """
  ## Display the Code of each Component
  iex> components_to_code("./test/support/example_components")
  [~s(<%= component "Buttons/primary_button", value: "I'm a Primary Button" %>\n),
  ~s(<%= component "Links/secondary_button", value: "I'm a Secondary Button" %>\n)]
  iex> components_to_code("./test/controllers")
  []
  """

  def components_to_code(file_path) do
    file_path
    |> get_example_full_path
    |> Enum.map(&(File.read!("#{&1}")))
  end

end
