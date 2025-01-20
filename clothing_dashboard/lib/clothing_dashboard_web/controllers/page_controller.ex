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

  def statistics(conn, params) do
    selected_month = params["month"]
    [month, year] = case selected_month do
      nil -> [nil, nil]
      encoded_month -> 
        decoded = URI.decode(encoded_month)
        [month, year] = String.split(decoded, ",")
        year = String.to_integer(year)
        [month, year]
    end

    stock = ProductService.get_total_stock()
    bestseller = TransactionService.get_bestseller_statistics()
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