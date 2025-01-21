defmodule ClothingDashboardWeb.ProductController do
    use ClothingDashboardWeb, :controller
    alias ClothingDashboard.ProductService
    alias ClothingDashboard.ProductValidator
    require Logger
  
    def create(conn, params) do
        with {:ok, _} <- ProductValidator.validate_required_fields(params),
            {:ok, price} <- ProductValidator.validate_price(params["price"]),
            {:ok, stock} <- ProductValidator.validate_stock(params["stock"]),
            {:ok, title} <- ProductValidator.validate_title(params["title"]),
            {:ok, description} <- ProductValidator.validate_description(params["description"]),
            {:ok, category} <- ProductValidator.validate_category(params["category"]),
            {:ok, photo_path} <- ProductValidator.handle_photo(params["photo"]) do
          
            product_params = %{
                title: title,
                stock: stock, 
                price: price,
                description: description,
                photo: photo_path,
                category: category
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
        else
        {:error, message} ->
            conn
            |> put_flash(:error, message)
            |> redirect(to: "/new")
        end
    end
end