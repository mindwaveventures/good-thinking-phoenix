defmodule App.Likes do
  @moduledoc false

  use App.Web, :model

  schema "likes" do
    field :user_hash, :string
    field :article_id, :integer
    field :like_value, :integer
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, [:user_hash, :article_id, :like_value])
    |> validate_required([:user_hash, :article_id, :like_value])
  end
end
