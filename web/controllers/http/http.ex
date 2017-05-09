defmodule App.Http.Http do
  @moduledoc false

  def post_spreadsheet(email, url, type) do
    HTTPotion.post url, [body: "#{type}=" <> URI.encode_www_form(email),
      headers: ["User-Agent": "App",
                "Content-Type": "application/x-www-form-urlencoded"]]
  end
end
