defmodule RemindMeWeb.HomeController do
  use RemindMeWeb, :controller

  import RemindMeWeb.Authorize

  plug :guest_check when action in [:index]

  def index(conn, _params) do
    render conn, "index.html"
  end
end
