defmodule App.SessionController do
  use App.Web, :controller

  alias App.Auth

  def new(conn, _params) do
    case conn.assigns[:current_user] do
      nil ->
        render conn, "new.html"
      user ->
        redirect(conn, to: homepage_path(conn, :index))
      end
  end

  def create(conn, %{"session" => %{"username" => user, "password" => pass}}) do
    case Auth.login_by_username_and_password(conn, user, pass, repo: Repo) do
      {:ok, conn} ->
        conn
        |> redirect(to: homepage_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> render("new.html")
    end
  end
end
