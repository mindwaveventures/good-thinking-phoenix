defmodule App.Http.Http do
  @moduledoc false

  def post_spreadsheet(input_list, url, tab_name) do
    vals_to_insert = 
      input_list
      |> Enum.map(&URI.encode_www_form/1)
      |> Enum.join("__ldmw_delimiter__")

    HTTPotion.post url, [body: "#{tab_name}=#{vals_to_insert}",
      headers: ["User-Agent": "App",
                "Content-Type": "application/x-www-form-urlencoded"]]
  end
end
