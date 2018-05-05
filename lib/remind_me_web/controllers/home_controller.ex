defmodule RemindMeWeb.HomeController do
  use RemindMeWeb, :controller

  import RemindMeWeb.Authorize

  plug(:guest_check when action in [:index])
  plug(:user_check when action not in [:index])

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def dashboard(conn, _params) do
    render(conn, "dashboard.html")
  end
end
