defmodule App.ComponentView do
  use App.Web, :view

  @yt_url ~r/youtube\.com\/watch\?.*v=([^&#]+).*$/
  @short_yt_url ~r/youtu\.be\/([^?#]*)/

  @doc """
  ## Get Video ID from youtube url
  iex> getVideoId("youtu.be/frg65dhyu")
  "frg65dhyu"
  iex> getVideoId("https://youtube.com/watch?v=hs8fm36fyrh")
  "hs8fm36fyrh"
  iex> getVideoId("https://youtube.com/watch?v=n475fgctdy#t=24")
  "n475fgctdy"
  iex> getVideoId("https://youtube.com/watch?hello=world&v=8fjry63nd#t=24")
  "8fjry63nd"
  """
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
