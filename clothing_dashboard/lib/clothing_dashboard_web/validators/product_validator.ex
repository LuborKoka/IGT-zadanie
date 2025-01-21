defmodule ClothingDashboard.ProductValidator do
    def validate_required_fields(params) do
        required_fields = ["title", "stock", "price", "description", "category", "photo"]
        case Enum.all?(required_fields, &Map.has_key?(params, &1)) do
            true -> {:ok, nil}
            false -> {:error, "All fields are required"}
        end
    end
      
    def validate_title(title) when is_binary(title) do
        case String.length(title) do
            len when len in 1..255 -> {:ok, title}
            0 -> {:error, "Title cannot be empty"}
            _ -> {:error, "Title must be less than 255 characters"}
        end
    end
    def validate_title(_), do: {:error, "Invalid title format"}
      
      def validate_stock(stock) when is_binary(stock) do
        case Integer.parse(stock) do
            {number, ""} when number > 0 -> {:ok, number}
            _ -> {:error, "Stock must be a positive number"}
        end
    end
    def validate_stock(_), do: {:error, "Invalid stock format"}
      
    def validate_price(price) when is_binary(price) do
        case Float.parse(price) do
            {number, ""} when number > 0 -> {:ok, number}
            _ -> {:error, "Price must be a positive number"}
        end
    end
    def validate_price(_), do: {:error, "Invalid price format"}
      
    def validate_description(description) when is_binary(description) do
        case String.length(description) do
            len when len in 1..10_000 -> {:ok, description}
            0 -> {:error, "Description cannot be empty"}
            _ -> {:error, "Description is too long (maximum is 10000 characters)"}
        end
    end
    def validate_description(_), do: {:error, "Invalid description format"}
      
    def validate_category(category) when is_binary(category) do 
        # este by som mohol porovnat case insensitive s existujucimi kategoriami
        # aby sa nestalo, ze napr Pants a pants a pAnTs budu 3 rozdielne kategorie
        case String.length(category) do
            len when len > 0 -> {:ok, category}
            _ -> {:error, "Category cannot be empty"}
        end
    end
    def validate_category(_), do: {:error, "Invalid category format"}
      
    def handle_photo(%Plug.Upload{} = upload) do
        extension = Path.extname(upload.filename)
        if extension in [".jpg", ".jpeg", ".png", ".gif"] do
            filename = "#{Ecto.UUID.generate()}#{extension}"
            dest = Path.join("priv/static/images/product_images", filename)
            
            case File.cp(upload.path, dest) do
                :ok -> {:ok, "/images/product_images/#{filename}"}
                _ -> {:error, "Failed to save image"}
            end
        else
            {:error, "Invalid file format. Allowed formats: JPG, JPEG, PNG, GIF"}
        end
    end
    def handle_photo(_), do: {:error, "Invalid photo format"}

end