defmodule ClothingDashboardWeb.DashboardLive do
    use ClothingDashboardWeb, :live_view
    alias ClothingDashboard.ProductService
    import ClothingDashboardWeb.ProductComponent
    require Logger
  
    def mount(_params, _session, socket) do
        socket = socket
          |> assign(:products, ProductService.get_all_products())
          |> assign(:editing, %{})
        {:ok, socket, layout: false}
      end

      def handle_event("toggle_edit", %{"field" => field, "id" => id}, socket) do
        editing = Map.get(socket.assigns, :editing, %{})
        key = {String.to_integer(id), field}  # Create tuple key with ID and field
        
        editing = if Map.get(editing, key) do
            Map.delete(editing, key)
        else
            Map.put(editing, key, true)
        end
        
        {:noreply, assign(socket, editing: editing)}
    end

    def handle_event("update_product", params, socket) do
        Logger.info("string")
        Logger.debug("debuf")
      
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