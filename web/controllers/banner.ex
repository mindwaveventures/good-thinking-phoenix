defmodule App.Banner do
  @moduledoc """
  # Gets banner text from CMS database, then assigns it to the connection
  # so it's available in all templates
  """
  import Plug.Conn
  alias App.{Resources}

  @doc"""
    iex>init(true)
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
