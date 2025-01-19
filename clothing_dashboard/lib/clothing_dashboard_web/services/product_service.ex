defmodule ClothingDashboard.ProductService do
    alias ClothingDashboard.Repo
    alias ClothingDashboard.Product
  
    @doc """
    Fetches all products from the database.
  
    ## Examples
  
        iex> ClothingDashboard.ProductService.get_all_products()
        [%Product{}, %Product{}]
    """
    def get_all_products do
      Repo.all(Product)
    end
  
    @doc """
    Fetches a product by its ID from the database.
  
    ## Parameters
    - id: The ID of the product to fetch.
  
    ## Examples
  
        iex> ClothingDashboard.ProductService.get_product_by_id(1)
        %Product{}
  
        iex> ClothingDashboard.ProductService.get_product_by_id(999)
        nil
    """
    def get_product_by_id(id) do
      Repo.get(Product, id)
    end

    @doc """
  Deletes a product from the database.
  """
  def delete_product(id) do
    Product
    |> Repo.get(id)
    |> case do
      nil -> {:error, :not_found}
      product -> Repo.delete(product)
    end
  end
end
  