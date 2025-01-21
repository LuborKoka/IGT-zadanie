defmodule ClothingDashboard.ProductService do
    alias ClothingDashboard.Repo
    alias ClothingDashboard.Product
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
end
  