defmodule ClothingDashboardWeb.ProductComponent do
  use Phoenix.Component

  attr :product, :map, required: true
  attr :editing, :map, required: true

  def product_card(assigns) do

    ~H"""
    <div class="border rounded-lg p-4 shadow relative grid" id={"product-#{@product.id}"}>
      <button 
        phx-click={"delete_product"}
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
      <div>
        <b class="text-xl capitalize text-center block"><%= @product.title %></b>
        <p class="text-gray-600 text-justify"><%= @product.description %></p>
      </div>

      <div class="self-end">
        <img src={@product.photo} class="rounded justify-self-center my-2" alt="product_image" />
        
        <p class="text-lg mt-2">
          <%= if @editing[{@product.id, "price"}] do %>
            <form class="flex items-center gap-2" phx-submit="update_product">
              <input 
                autofocus
                type="text" 
                name="value"
                value={@product.price} 
                class="border rounded w-20 px-2"
                phx-blur="toggle_edit"
                phx-value-field="price"
                phx-value-id={@product.id}
              />
              <input type="hidden" name="id" value={@product.id} />
              <input type="hidden" name="field" value="price" />
            </form>
          <% else %>
            Cost: <b><%= @product.price %>€</b>
            <svg 
              class="w-6 h-6 text-gray-800 dark:text-white inline cursor-pointer" 
              aria-hidden="true" 
              xmlns="http://www.w3.org/2000/svg" 
              width="24" 
              height="24" 
              fill="none" 
              viewBox="0 0 24 24"
              phx-click="toggle_edit"
              phx-value-field="price"
              phx-value-id={@product.id}
            >
              <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.779 17.779 4.36 19.918 6.5 13.5m4.279 4.279 8.364-8.643a3.027 3.027 0 0 0-2.14-5.165 3.03 3.03 0 0 0-2.14.886L6.5 13.5m4.279 4.279L6.499 13.5m2.14 2.14 6.213-6.504M12.75 7.04 17 11.28"/>
            </svg>  
          <% end %>
        </p>
          
        <p class="text-lg mt-2">
          <%= if @editing[{@product.id, "stock"}] do %>
            <form phx-submit="update_product">
              <input 
                autofocus
                type="text" 
                name="value"
                value={@product.stock} 
                class="border rounded w-20 px-2"
                phx-blur="toggle_edit"
                phx-value-field="stock"
                phx-value-id={@product.id}
              />
              <input type="hidden" name="id" value={@product.id} />
              <input type="hidden" name="field" value="stock" />
            </form>
          <% else %>
            Stock: <b><%= @product.stock %> pcs</b>
            <svg 
              class="w-6 h-6 text-gray-800 dark:text-white inline cursor-pointer" 
              aria-hidden="true" 
              xmlns="http://www.w3.org/2000/svg" 
              width="24" 
              height="24" 
              fill="none" 
              viewBox="0 0 24 24"
              phx-click="toggle_edit"
              phx-value-field="stock"
              phx-value-id={@product.id}
            >
              <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.779 17.779 4.36 19.918 6.5 13.5m4.279 4.279 8.364-8.643a3.027 3.027 0 0 0-2.14-5.165 3.03 3.03 0 0 0-2.14.886L6.5 13.5m4.279 4.279L6.499 13.5m2.14 2.14 6.213-6.504M12.75 7.04 17 11.28"/>
            </svg>
          <% end %>
          <p class="text-lg mt-2">
            Category: <b><%= @product.category %></b>
          </p>
        </p>
      </div>
    </div>
    """
  end
end