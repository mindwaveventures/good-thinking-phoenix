defmodule App.Http.Http do
  @moduledoc false
  @google_sheet_url Application.get_env :app, :google_sheet_url

  def post_spreadsheet(input_list, tab_name) do
    vals_to_insert =
      input_list
      |> Enum.map(&URI.encode_www_form/1)
      |> Enum.join("__ldmw_delimiter__")

    body = "#{tab_name}=#{vals_to_insert}"
    headers = ["User-Agent": "App",
               "Content-Type": "application/x-www-form-urlencoded"]

    HTTPotion.post @google_sheet_url, [body: body, headers: headers]
  end
end
