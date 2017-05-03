defmodule App.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table :users do
      add :username, :string
      add :password_hash, :string
    end
  end
end
