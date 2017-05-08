defmodule App.User do
  @moduledoc false

  use App.Web, :model

  alias Comeonin.Bcrypt

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, ~w[username])
    |> validate_required([:username])
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, ~w(password))
    |> validate_required([:password])
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
