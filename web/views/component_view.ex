defmodule App.ComponentView do
  use App.Web, :view

  @yt_url ~r/https:\/\/www\.youtube\.com\/watch\?.*v=([^&#]+).*$/
  @short_yt_url ~r/youtu\.be\/([^?#]*)/

  def getVideoId(url) do
    [@yt_url, @short_yt_url]
    |> Enum.map(&(getVideoId &1, url))
    |> Enum.find(fn el -> el end)
  end
  def getVideoId(regex, url) do
    regex
    |> Regex.run(url)
    |> case do
      nil -> nil
      list -> List.last list
    end
  end
end
