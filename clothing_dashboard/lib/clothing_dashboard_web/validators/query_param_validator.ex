defmodule ClothingDashboard.QueryParamValidator do
    def parse_categories_query_param(params) do
        case params["categories"] do
            nil -> nil
            categories when is_list(categories) -> 
                Enum.map(categories, &String.capitalize/1)
        end
    end

    def parse_month_year(selected_month) do
        case selected_month do
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