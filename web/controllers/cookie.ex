defmodule App.Cookie do
  import Plug.Conn

  def init(args), do: args

  def call(conn, _) do
    session_id = get_session conn, :lm_session
    cond do
      session_id -> conn
      true -> put_session conn, :lm_session, gen_rand_string(80)
    end
  end

  def gen_rand_string(length) do
    length |> :crypto.strong_rand_bytes |> Base.url_encode64
  end
end
