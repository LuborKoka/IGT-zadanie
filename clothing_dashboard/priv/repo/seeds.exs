# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ClothingDashboard.Repo.insert!(%ClothingDashboard.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ClothingDashboard.Repo
alias ClothingDashboard.Product
alias ClothingDashboard.Transaction

defmodule Seeder do
    @categories ["Shirts", "Pants", "Shoes", "Hats"]

    def seed(x, n) do
        multiply_seeder(x, n)
        |> Enum.map(fn _ -> 
            product = product_seed()
            transaction_seed(product)
            product
        end)
        |> List.last()
        |> transaction_seed()
    end
      
    def multiply_seeder(x, n), do: Stream.cycle([1]) |> Enum.take(n * x)


    def product_seed do 
        Repo.insert!(%Product{
            photo: "images/product_images/placeholder.jpeg",
            title: Faker.Lorem.word,
            description: Faker.Lorem.paragraph,
            stock: :rand.uniform(100),
            price: :rand.uniform() * 100 |> Float.round(2),
            category: Enum.random(@categories)
        })
    end

    def transaction_seed(product) do 
        count = :rand.uniform(10)
        Repo.insert!(%Transaction{
            item_name: product.title,
            item_count: count,
            total_cost: product.price * count,
            product_id: product.id
        })
    end

end

Seeder.seed(1, 10)