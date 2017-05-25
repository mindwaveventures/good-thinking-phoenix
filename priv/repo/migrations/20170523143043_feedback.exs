defmodule App.Repo.Migrations.Feedback do
  use Ecto.Migration

  def change do
    create table :feedback do
      add :user_hash, :string
      add :tab_name, :string
      add :data, {:array, :string}
    end
  end
end
