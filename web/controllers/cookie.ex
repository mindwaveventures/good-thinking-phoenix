defmodule App.Cookie do
  @moduledoc false
  import Plug.Conn

  @doc"""
    iex>App.Cookie.init(true)
    true
  """
  def init(args), do: args

  def call(conn, _) do
    case session_id = get_session conn, :lm_session do
      nil -> put_session conn, :lm_session, gen_rand_string(80)
      _ -> conn
    end
  end

  def gen_rand_string(length) do
    length |> :crypto.strong_rand_bytes |> Base.url_encode64
  end
end
