defmodule MarketplaceWeb.PlayerSessionController do
  use MarketplaceWeb, :controller

  alias Marketplace.Accounts
  alias MarketplaceWeb.PlayerAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"player" => player_params}) do
    %{"email" => email, "password" => password} = player_params

    if player = Accounts.get_player_by_email_and_password(email, password) do
      PlayerAuth.log_in_player(conn, player, player_params)
    else
      render(conn, "new.html", error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> PlayerAuth.log_out_player()
  end
end
