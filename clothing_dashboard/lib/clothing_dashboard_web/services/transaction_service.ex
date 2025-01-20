defmodule ClothingDashboard.TransactionService do
    alias ClothingDashboard.{Transaction, Repo, ProductService}
    import Ecto.Query

    def get_transactions_by_month(month, year) do
        case {month, year} do
            {nil, nil} ->
                from(t in Transaction,
                    order_by: [asc: t.inserted_at]
                )
                |> Repo.all()
            {month, year} ->
                from(t in Transaction,
                    where: fragment("TO_CHAR(?, 'FMMonth') = ? AND EXTRACT(YEAR FROM ?) = ?", t.inserted_at, ^month, t.inserted_at, ^year),
                    order_by: [asc: t.inserted_at]
                    )
                |> Repo.all()
        end
    end

    def get_transactions_months() do 
        query =
            from t in Transaction,
                distinct: true,
                select: %{
                    month: fragment("to_char(?, 'FMMonth')", t.inserted_at),
                    year: fragment("EXTRACT(YEAR FROM ?)", t.inserted_at)
                }

        Repo.all(query)
    end

    def get_bestseller() do
        query =
            from t in Transaction,
                group_by: [t.product_id, t.item_name],
                select: {count(t.product_id), t.product_id},
                order_by: [desc: count(t.product_id)],
                limit: 1

        { count, product_id } = Repo.one(query)

        ProductService.get_product_by_id(product_id)
    end

    def get_bestseller_statistics() do
        query =
            from t in Transaction,
                group_by: [t.product_id, t.item_name],
                select: {count(t.item_name), t.product_id, sum(t.item_count), sum(t.total_cost), t.item_name},
                order_by: [desc: count(t.item_name), desc: sum(t.item_count)],
                limit: 1

        { transaction_count, product_id, sold_item_count, total_cost, item_name } = Repo.one(query)

        # neni som si este uplne isty, na co mi ta referencia je, ale raz sa mozno este zide
        # ale zide sa 😁
        product = ProductService.get_product_by_id(product_id)

        %{
            title: item_name,
            sold_item_count: sold_item_count,
            total_cost: total_cost,
            transaction_count: transaction_count,
            product: product
        }
    end
    



end