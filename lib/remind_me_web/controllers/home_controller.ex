defmodule RemindMeWeb.HomeController do
  use RemindMeWeb, :controller

  alias RemindMe.Repo

  import RemindMeWeb.Authorize

  plug(:user_check when action not in [:index])

  def dashboard(conn, _params) do
    user = conn.assigns.current_user |> Repo.preload(:connections)
    connection = user.connections |> hd() |> Repo.preload([:server_number, :client_number])
    render(conn, "dashboard.html", user: user, connection: connection)
  end
end
