defmodule App.TestHelpers do
  alias App.{Repo, User}
  alias Plug.Conn
  alias Phoenix.ConnTest

  def insert_user(attrs \\ %{}) do
    changes = Map.merge(%{
      username: "Some_User",
      password: "supersecret"
    }, attrs)

    %User{}
    |> User.registration_changeset(changes)
    |> Repo.insert!()
  end

  def login_user(%{conn: conn} = config) do
    if username = config[:login_as] do
      user = %{email: username, password: "secret"}
        |> insert_user
      conn = Conn.assign(ConnTest.build_conn(), :current_user, user)
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end
end
