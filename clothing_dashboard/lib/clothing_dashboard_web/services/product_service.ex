defmodule ClothingDashboard.ProductService do
    alias ClothingDashboard.{Product, Transaction, Repo}
    import Ecto.Query
  
    def get_all_products do
        Repo.all(Product)
    end
  

    def get_product_by_id(nil), do: nil
    def get_product_by_id(id), do: Repo.get(Product, id)

    def get_products_by_categories(categories) do
        from(p in Product, where: p.category in ^categories)
        |> Repo.all()
    end


    def create_product(attrs) do
        %Product{}
        |> Product.changeset(attrs)
        |> Repo.insert()
    end


    def delete_product(id) do
        Product
        |> Repo.get(id)
        |> case do
            nil -> 
                {:error, :not_found}
            product ->
                image_path = "./priv/static/#{product.photo}"
                File.rm(image_path)
                |> case do
                :ok -> Repo.delete(product)
                {:error, reason} -> {:error, :file_delete_failed, reason}
                end
        end
    end

    def update_product(id, attrs) do
        Product
        |> Repo.get(id)
        |> case do
        nil -> {:error, :not_found}
        product -> product |> Product.changeset(attrs) |> Repo.update()
        end
    end


    def get_distinct_categories do
        Repo.all(from p in Product, distinct: true, select: p.category)
    end


    def get_total_stock do
        products = get_all_products()
        products_with_income = products
            |> Enum.map(fn product -> 
                Map.put(product, :income, Decimal.mult(product.price, Decimal.new(product.stock)))
            end)
    

        query = from p in "products",
            select: %{
                potential_income: sum(fragment("? * ?", p.price, p.stock)),
                stock: sum(p.stock)
            }

        %{
            total: Repo.one(query),
            products: products_with_income
        }
    end

    def get_bestseller() do
        query =
            from t in Transaction,
                group_by: [t.product_id, t.item_name],
                select: {count(t.product_id), t.product_id},
                order_by: [desc: count(t.product_id)],
                limit: 1

        { count, product_id } = Repo.one(query)

        get_product_by_id(product_id)
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
        product = get_product_by_id(product_id)

        %{
            title: item_name,
            sold_item_count: sold_item_count,
            total_cost: total_cost,
            transaction_count: transaction_count,
            product: product
        }
    end
end
  