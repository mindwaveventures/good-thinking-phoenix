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
  def getVideoId(url),
    do: getVideoId(@yt_url, url) || getVideoId(@short_yt_url, url)
  def getVideoId(regex, url),
    do: (regex |> Regex.run(url) || []) |> List.last

  def name_to_atom(name) when is_atom(name), do: name
  def name_to_atom(name), do: String.to_atom(name)
end
