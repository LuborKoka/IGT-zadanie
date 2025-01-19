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

products = [
    # Shirts
    %{
        photo: "placeholder.jpg",
        title: "Basic White Shirt",
        description: "A classic white shirt made of soft cotton.",
        category: "Shirts",
        price: 19.99,
        stock: 100
    },
    %{
        photo: "placeholder.jpg",
        title: "Blue Denim Shirt",
        description: "A stylish blue denim shirt for all occasions.",
        category: "Shirts",
        price: 29.99,
        stock: 75
    },
    %{
        photo: "placeholder.jpg",
        title: "Striped Button-Down Shirt",
        description: "A smart striped shirt for casual and formal wear.",
        category: "Shirts",
        price: 24.99,
        stock: 60
    },
    %{
        photo: "placeholder.jpg",
        title: "Plaid Flannel Shirt",
        description: "A cozy plaid flannel shirt perfect for cold weather.",
        category: "Shirts",
        price: 34.99,
        stock: 50
    },
  
    # Pants
    %{
        photo: "placeholder.jpg",
        title: "Black Dress Pants",
        description: "Formal black pants for business or special events.",
        category: "Pants",
        price: 39.99,
        stock: 50
    },  
    %{  
        photo: "placeholder.jpg",
        title: "Khaki Chinos",
        description: "Comfortable and stylish khaki chinos for everyday wear.",
        category: "Pants",
        price: 34.99,
        stock: 60
    },
    
        # Shoes
    %{
        photo: "placeholder.jpg",
        title: "Leather Sneakers",
        description: "Durable and comfortable leather sneakers for casual wear.",
        category: "Shoes",
        price: 69.99,
        stock: 40
    },
    %{
        photo: "placeholder.jpg",
        title: "Running Shoes",
        description: "High-performance running shoes for athletes.",
        category: "Shoes",
        price: 89.99,
        stock: 30
    },
    
        # Hats
    %{
        photo: "placeholder.jpg",
        title: "Baseball Cap",
        description: "A classic baseball cap with adjustable straps.",
        category: "Hats",
        price: 14.99,
        stock: 120
    },
    %{
        photo: "placeholder.jpg",
        title: "Wool Beanie",
        description: "Warm and cozy wool beanie for cold weather.",
        category: "Hats",
        price: 19.99,
        stock: 80
    }
]
  

Enum.each(products, fn product ->
  Repo.insert!(%Product{photo: product.photo, title: product.title, description: product.description, category: product.category, price: product.price, stock: product.stock})
end)
