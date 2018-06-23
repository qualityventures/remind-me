defmodule RemindMeWeb.HomeController do
  use RemindMeWeb, :controller

  alias RemindMe.Repo

  import RemindMeWeb.Authorize

  plug(:guest_check when action in [:index])
  plug(:user_check when action not in [:index])

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def dashboard(conn, _params) do
    user = conn.assigns.current_user |> Repo.preload(:connections)
    connection = user.connections |> hd() |> Repo.preload([:server_number, :client_number])
    render(conn, "dashboard.html", user: user, connection: connection)
  end
end
