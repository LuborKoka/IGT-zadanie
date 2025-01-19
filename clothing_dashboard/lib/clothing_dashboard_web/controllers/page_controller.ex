defmodule ClothingDashboardWeb.PageController do
  use ClothingDashboardWeb, :controller
  alias ClothingDashboard.ProductService

  def home(conn, _params) do
    products = ProductService.get_all_products()
    render(conn, :dashboard, layout: false, products: products)
  end
end