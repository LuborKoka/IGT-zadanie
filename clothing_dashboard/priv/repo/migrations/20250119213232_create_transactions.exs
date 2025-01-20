defmodule ClothingDashboard.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :total_cost, :float
      add :item_count, :integer
      add :item_name, :string
      add :product_id, references(:products, on_delete: :nilify_all)

      timestamps(type: :utc_datetime)
    end
  end
end
