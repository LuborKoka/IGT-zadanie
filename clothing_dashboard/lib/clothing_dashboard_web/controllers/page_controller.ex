defmodule ClothingDashboardWeb.PageController do
  use ClothingDashboardWeb, :controller
  alias ClothingDashboard.{ProductService, TransactionService}

  def home(conn, _params) do
    products = ProductService.get_all_products()
    render(conn, :dashboard, layout: false, products: products)
  end

  def new(conn, _params) do
    categories = ProductService.get_distinct_categories()
    render(conn, :new, layout: false, categories: categories)
  end

  def statistics(conn, _params) do
    total_stock = ProductService.get_total_stock()
    bestseller = TransactionService.get_bestseller_statistics()
    render(conn, :statistics, layout: false, total_stock: total_stock, bestseller: bestseller)
  end

end