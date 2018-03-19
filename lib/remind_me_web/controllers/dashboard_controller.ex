defmodule RemindMeWeb.DashboardController do
  use RemindMeWeb, :controller

  import RemindMeWeb.Authorize

  plug :user_check

  def index(conn, _params) do
    render conn, "index.html"
  end
end
