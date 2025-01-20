defmodule ClothingDashboard.ProductService do
    alias ClothingDashboard.Repo
    alias ClothingDashboard.Product
    import Ecto.Query
  
    def get_all_products do
        Repo.all(Product)
    end
  

    def get_product_by_id(id) do
        Repo.get(Product, id)
    end

    def get_products_by_category(category) do
        from(p in Product, where: p.category == ^category)
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
        nil -> {:error, :not_found}
        product -> Repo.delete(product)
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
        query = from p in Product, select: sum(p.stock)
        Repo.one(query)
    end
end
  