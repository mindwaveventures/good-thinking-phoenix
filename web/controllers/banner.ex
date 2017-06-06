defmodule App.Banner do
  @moduledoc false
  import Plug.Conn
  alias App.{Resources}

  @doc"""
    iex>App.Banner.init(true)
    true
  """
  def init(args), do: args

  def call(conn, _) do
    assign(conn, :banner, get_banner_text())
  end

  def get_banner_text do
    Resources.get_content(:banner)
  end
end
