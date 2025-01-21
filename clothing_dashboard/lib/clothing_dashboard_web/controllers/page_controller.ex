defmodule ClothingDashboardWeb.PageController do
  use ClothingDashboardWeb, :controller
  alias ClothingDashboard.{ProductService, TransactionService, QueryParamValidator}

  def home(conn, _params) do
    products = ProductService.get_all_products()
    render(conn, :dashboard, layout: false, products: products)
  end

  def new(conn, _params) do
    categories = ProductService.get_distinct_categories()
    render(conn, :new, layout: false, categories: categories)
  end

  def auth(conn, _params) do 
    render(conn, :auth, layout: false)
  end

  def statistics(conn, params) do
    selected_month = params["month"]
    [month, year] = QueryParamValidator.parse_month_year(selected_month)

    stock = ProductService.get_total_stock()
    bestseller = ProductService.get_bestseller_statistics()
    transactions = TransactionService.get_transactions_by_month(month, year)
    months = TransactionService.get_transactions_months()
    render(
      conn, 
      :statistics, 
      layout: false, 
      stock: stock, 
      bestseller: bestseller, 
      transactions: transactions,
      months: months,
      selected_month: selected_month
    )
  end
end