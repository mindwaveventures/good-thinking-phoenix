defmodule App.User do
  use App.Web, :model

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
  end
end
