defmodule ClothingDashboard.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :total_cost, :float
    field :item_count, :integer
    field :item_name, :string
    belongs_to :product, ClothingDashboard.Product

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:total_cost, :item_count, :item_name, :product_id])
    |> validate_required([:total_cost, :item_count, :item_name])
    |> foreign_key_constraint(:product_id)
  end
end