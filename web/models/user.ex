defmodule App.User do
  @moduledoc false

  use App.Web, :model

  alias Comeonin.Bcrypt
  alias Ecto.Changeset

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, [:username])
    |> validate_required(:username)
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required(:password)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
