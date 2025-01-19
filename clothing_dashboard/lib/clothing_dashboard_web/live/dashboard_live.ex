defmodule ClothingDashboardWeb.DashboardLive do
    use ClothingDashboardWeb, :live_view
    alias ClothingDashboard.ProductService
    import ClothingDashboardWeb.ProductComponent
  
    def mount(params, _session, socket) do
        products = case params["category"] do
            nil -> ProductService.get_all_products()
            category -> ProductService.get_products_by_category(category)
        end

        socket = socket
          |> assign(:products, products)
          |> assign(:categories, ProductService.get_distinct_categories())
          |> assign(:editing, %{})
        {:ok, socket, layout: false}
    end
    

    def handle_event("toggle_category", %{"category" => category}, socket) do
        {:noreply, push_navigate(socket, to: ~p"/?category=#{category}")}
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
      
        parsed_value = case field do
          "price" -> 
            {float_value, _} = Float.parse(value)
            float_value
          _ -> value
        end
      
      
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
  
    def handle_event("delete_product", %{"id" => id}, socket) do
        case ProductService.delete_product(id) do
            {:ok, _product} ->
            products = socket.assigns.products |> Enum.reject(&(&1.id == String.to_integer(id)))
            {:noreply, assign(socket, products: products)}
    
            {:error, _reason} ->
            {:noreply, put_flash(socket, :error, "Failed to delete product")}
        end
    end
end