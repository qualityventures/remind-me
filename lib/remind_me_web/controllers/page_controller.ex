defmodule RemindMeWeb.PageController do
  use RemindMeWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
