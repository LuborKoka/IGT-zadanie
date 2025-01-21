defmodule ClothingDashboard.LabeledInput do
    use Phoenix.Component

    attr :name, :string, required: true
    attr :id, :string, required: true
    attr :placeholder, :string, required: true
    attr :type, :string, required: false, default: "text"
    attr :min, :string, required: false, default: "1"
    attr :is_textarea, :boolean, required: false, default: false
    attr :wrapper_classes, :string, required: false, default: ""

    def labeled_input(assigns) do
        ~H"""
            <div class={"relative w-full group #{@wrapper_classes}"}>
                <%= if @is_textarea do %>
                    <textarea  id={@id}  name={String.downcase(@name)}  required  class="peer w-full bg-transparent px-5 py-4 text-xl border rounded outline-none transition-shadow duration-300 hover:shadow-lg focus:shadow-lg focus:border-green-500 focus:ring-green-500 valid:shadow-lg valid:border-green-500 valid:ring-green-500" />
                <% else %>
                    <input id={@id} name={String.downcase(@name)} min={@min} type={@type} required class="peer w-full bg-transparent px-5 py-4 text-xl border rounded outline-none transition-shadow duration-300 hover:shadow-lg focus:shadow-lg focus:border-green-500 focus:ring-green-500 valid:shadow-lg valid:border-green-500 valid:ring-green-500"/>
                <% end %>
                <label for={@id} class="absolute left-4 top-4 text-xl pointer-events-none bg-white transition-all duration-300 peer-focus:-translate-y-full peer-focus:text-base peer-valid:-translate-y-full peer-valid:text-base peer-placeholder-shown:translate-y-0 peer-placeholder-shown:text-xl">
                    <%= @placeholder %>
                </label>
            </div>
        """
    end

end