defmodule App.Feedback do
  @moduledoc false

  use App.Web, :model

  schema "feedback" do
    field :user_hash, :string
    field :tab_name, :string
    field :data, {:array, :string}
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, [:user_hash, :tab_name, :data])
    |> validate_required([:user_hash, :tab_name, :data])
  end
end
