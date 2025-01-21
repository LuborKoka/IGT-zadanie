defmodule ClothingDashboard.TransactionService do
    alias ClothingDashboard.{Transaction, Repo}
    import Ecto.Query

    def get_transactions_by_month(month, year) do
        case {month, year} do
            {nil, nil} ->
                from(t in Transaction,
                    order_by: [asc: t.inserted_at]
                )
                |> Repo.all()
            {month, year} ->
                from(t in Transaction,
                    where: fragment("TO_CHAR(?, 'FMMonth') = ? AND EXTRACT(YEAR FROM ?) = ?", t.inserted_at, ^month, t.inserted_at, ^year),
                    order_by: [asc: t.inserted_at]
                    )
                |> Repo.all()
        end
    end

    def get_transactions_months() do 
        query =
            from t in Transaction,
                distinct: true,
                select: %{
                    month: fragment("to_char(?, 'FMMonth')", t.inserted_at),
                    year: fragment("EXTRACT(YEAR FROM ?)", t.inserted_at)
                }

        Repo.all(query)
    end
end