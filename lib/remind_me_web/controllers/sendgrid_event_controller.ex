defmodule RemindMeWeb.SendgridEventController do
  use RemindMeWeb, :controller

  def process(conn, params) do
    json conn, Poison.encode! params
  end
end