defmodule App.Repo.Migrations.AddLikesTable do
  use Ecto.Migration

  def change do
    create table :likes do
      add :user_hash, :string
      add :article_id, :integer
      add :like_value, :integer
    end
  end
end
