defmodule ClothingDashboardWeb.ProductComponent do
  use Phoenix.Component
  import Phoenix.LiveView

  attr :product, :map, required: true
  attr :on_delete, :string, required: true

  def product_card(assigns) do
    ~H"""
    <div class="border rounded-lg p-4 shadow relative" id={"product-#{@product.id}"}>
      <button 
        phx-click={@on_delete}
        phx-value-id={@product.id}
        class="absolute top-2 right-2 text-red-500 hover:text-red-700"
        data-confirm="Are you sure you want to delete this product?"
      >
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M3 6h18"></path>
          <path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"></path>
          <path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"></path>
          <line x1="10" y1="11" x2="10" y2="17"></line>
          <line x1="14" y1="11" x2="14" y2="17"></line>
        </svg>
      </button>
      <h2 class="text-xl font-semibold"><%= @product.title %></h2>
      <p class="text-gray-600"><%= @product.description %></p>
      <p class="text-lg font-bold mt-2">$<%= @product.price %></p>
      <p class="text-lg font-bold mt-2"><%= @product.stock %> pcs</p>
    </div>
    """
  end
end