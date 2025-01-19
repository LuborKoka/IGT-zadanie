defmodule ClothingDashboardWeb.DashboardLive do
    use ClothingDashboardWeb, :live_view
    alias ClothingDashboard.ProductService
    import ClothingDashboardWeb.ProductComponent
  
    def mount(_params, _session, socket) do
        if connected?(socket), do: Process.send_after(self(), :update, 100)
        socket = assign(socket, products: ProductService.get_all_products())
        {:ok, socket, layout: false}  # Add layout: false here
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