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

  def auth(conn, _params) do 
    render(conn, :auth, layout: false)
  end

  def statistics(conn, params) do
    selected_month = params["month"]
    [month, year] = case selected_month do
      nil -> [nil, nil]
      encoded_month -> 
        decoded = URI.decode(encoded_month)
        with(
          [month, year] <- String.split(decoded, ",") |> validate_parts(),
          true <- validate_month(month),
          {:ok, year_str} <- validate_year(year),
          {year_int, _} <- Integer.parse(year_str)
        ) do
          [String.capitalize(month), year_int]
        else
          _ -> [nil, nil]
        end
    end

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

  defp validate_parts(parts) when length(parts) == 2, do: parts
  defp validate_parts(_), do: nil


  defp validate_month(month) do
    valid_months = [
      "january", "february", "march", "april", "may", "june",
      "july", "august", "september", "october", "november", "december"
    ]
    String.downcase(month) in valid_months
  end


  defp validate_year(year) do
    case Integer.parse(year) do
      {_year_int, ""} -> {:ok, year}
      _ -> :error
    end
  end
end