defmodule App.Http.Http do
  @moduledoc false
  @google_sheet_url Application.get_env(:app, :google_sheet_url)

  def post_spreadsheet(email) do
    url = @google_sheet_url

    HTTPotion.post url, [body: "email=" <> URI.encode_www_form(email),
      headers: ["User-Agent": "App",
                "Content-Type": "application/x-www-form-urlencoded"]]
  end
end
