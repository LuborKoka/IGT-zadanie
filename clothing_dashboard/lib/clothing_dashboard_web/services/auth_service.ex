defmodule ClothingDashboardWeb.AuthService do
    import Phoenix.Controller, only: [redirect: 2, json: 2]
    import Plug.Conn, only: [put_status: 2]

    def init(opts), do: opts

    def call(conn, opts) do
        handle_auth_action(conn, conn.params)
    end

    def handle_auth_action(conn, params) do
        case params["action"] do
          "login" -> handle_login(conn, params)
          "signup" -> handle_signup(conn, params)
          _ -> conn |> put_status(:bad_request) |> json(%{error: "Invalid action"})
    end
    end
    
    defp handle_login(conn, params) do
        # validate input, get user by email, validate password hash, then reroute or something with user credentials
        conn
        |> redirect(to: "/")
    end
    
    defp handle_signup(conn, params) do
    end

end