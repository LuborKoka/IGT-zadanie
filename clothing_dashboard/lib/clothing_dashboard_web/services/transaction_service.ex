defmodule ClothingDashboard.TransactionService do
    alias ClothingDashboard.{Transaction, Product, Repo, ProductService}
    import Ecto.Query

    def get_bestseller() do
        query =
            from t in Transaction,
                group_by: t.product_id,
                select: {count(t.product_id), t.product_id, sum(t.item_count), sum(t.total_cost)},
                order_by: [desc: count(t.product_id)],
                limit: 1

        {count, product_id, count, cost} = Repo.one(query)

        ProductService.get_product_by_id(product_id)
    end


end