defmodule ClothingDashboardWeb.ProductController do
    use ClothingDashboardWeb, :controller
    alias ClothingDashboard.ProductService
    require Logger
  
    def create(conn, params) do
        price = case Float.parse(params["price"]) do
            {number, _} -> number
            :error -> nil
        end
        product_params = %{
            title: params["title"],
            stock: String.to_integer(params["stock"]),
            price: price,
            description: params["description"],
            photo: "placeholder.jpg",
            category: params["category"],
        }
    
        case ProductService.create_product(product_params) do
            {:ok, _product} ->
            conn
            |> put_flash(:info, "Product created successfully")
            |> redirect(to: "/")
    
            {:error, _changeset} ->
            conn
            |> put_flash(:error, "Error creating product")
            |> redirect(to: "/new")
        end
    end
end