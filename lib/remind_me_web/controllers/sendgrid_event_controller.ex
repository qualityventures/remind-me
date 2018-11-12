defmodule RemindMeWeb.SendgridEventController do
  use RemindMeWeb, :controller

  def process(conn, params) do
    json conn, Jason.encode! params
  end
end
