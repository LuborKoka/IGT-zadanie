defmodule ClothingDashboardWeb.DashboardLive do
    use ClothingDashboardWeb, :live_view
    alias ClothingDashboard.ProductService
    import ClothingDashboardWeb.ProductComponent
  
    def mount(params, _session, socket) do
      selected_categories = case params["categories"] do
        nil -> nil
        categories when is_list(categories) -> 
          Enum.map(categories, &String.capitalize/1)
      end

      products = case selected_categories do
        nil -> 
          ProductService.get_all_products()
        categories when is_list(categories) -> 
          ProductService.get_products_by_categories(categories)
      end

      socket = socket
        |> assign(:products, products)
        |> assign(:bestseller, ProductService.get_bestseller())
        |> assign(:categories, ProductService.get_distinct_categories())
        |> assign(:selected_categories, selected_categories)
        |> assign(:editing, %{})
      {:ok, socket, layout: false}
    end

    def handle_event("toggle_edit", %{"field" => field, "id" => id}, socket) do
        editing = Map.get(socket.assigns, :editing, %{})
        key = {String.to_integer(id), field} 
        
        editing = if Map.get(editing, key) do
            Map.delete(editing, key)
        else
            Map.put(editing, key, true)
        end
        
        {:noreply, assign(socket, editing: editing)}
    end

    def handle_event("update_product", params, socket) do
      %{"id" => id, "field" => field, "value" => value} = params
      
      case parse_value(field, value) do 
        {:error, message} ->
          {:noreply, put_flash(socket, :error, message)}
        parsed_value ->
          case ProductService.update_product(String.to_integer(id), %{String.to_atom(field) => parsed_value}) do
            {:ok, updated_product} ->
              products = Enum.map(socket.assigns.products, fn product ->
                if product.id == updated_product.id, do: updated_product, else: product
              end)
              {:noreply, assign(socket, products: products)}
        
            {:error, changeset} ->
              IO.inspect(changeset, label: "Error changeset")
              {:noreply, put_flash(socket, :error, "Failed to update product")}
          end
      end
    end
  
    def handle_event("delete_product", %{"id" => id}, socket) do
        case ProductService.delete_product(id) do
            {:ok, _product} ->
            products = socket.assigns.products |> Enum.reject(&(&1.id == String.to_integer(id)))
            {:noreply, assign(socket, products: products)}
    
            {:error, _reason} ->
            {:noreply, put_flash(socket, :error, "Failed to delete product")}
        end
    end


    defp parse_value(field, value) do
      case field do
        "price" -> 
          case Float.parse(value) do
            {float_value, _} when float_value > 0 -> 
              float_value
            _ ->
              {:error, "Price must be a positive number"}
          end
        "stock" -> 
          case Integer.parse(value) do
            {int_value, _} when int_value > 0 -> 
              int_value
            _ -> 
              {:error, "Stock value must be a positive integer"}
          end
        _ -> 
          {:error, "Invalid field: #{field}. Only 'price' and 'stock' are allowed."}
      end
    end
end