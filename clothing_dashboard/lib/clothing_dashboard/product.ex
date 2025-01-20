defmodule ClothingDashboard.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :title, :string
    field :category, :string
    field :photo, :string
    field :price, :decimal
    field :stock, :integer    # optional tuto este nejake contraints, ze stock musi byt >= 0

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:photo, :title, :description, :category, :price, :stock])
    |> validate_required([:photo, :title, :description, :category, :price, :stock])
    |> unique_constraint(:title)
  end
end
