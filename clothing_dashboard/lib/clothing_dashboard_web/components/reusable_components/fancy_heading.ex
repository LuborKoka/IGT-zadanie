defmodule ClothingDashboard.FancyHeading do
    use Phoenix.Component

    attr :title, :string, required: true
    attr :class, :string, required: false, default: ""

    def fancy_heading(assigns) do
        ~H"""
            <h1 class={"capitalize w-full text-white bg-green-400 border-8 border-green-500 rounder px-8 py-4 text-xl font-bold mb-8 #{@class}"}>
                <%= @title %>
            </h1>
        """
    end
end