defmodule ClothingDashboardWeb.PageController do
  use ClothingDashboardWeb, :controller
  alias ClothingDashboard.ProductService

  def home(conn, _params) do
    products = ProductService.get_all_products()
    render(conn, :dashboard, layout: false, products: products)
  end

  def new(conn, _params) do
    categories = ProductService.get_distinct_categories()
    render(conn, :new, layout: false, categories: categories)
  end

end