defmodule RemindMeWeb.ServerNumberController do
  use RemindMeWeb, :controller

  import RemindMeWeb.Authorize

  alias RemindMe.Connections
  alias RemindMe.Connections.ServerNumber

  plug(:admin_check)

  def index(conn, _params) do
    server_numbers = Connections.list_server_numbers()
    render(conn, "index.html", server_numbers: server_numbers)
  end

  def new(conn, _params) do
    changeset = Connections.change_server_number(%ServerNumber{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"server_number" => server_number_params}) do
    case Connections.create_server_number(server_number_params) do
      {:ok, server_number} ->
        conn
        |> put_flash(:info, "Server number created successfully.")
        |> redirect(to: server_number_path(conn, :show, server_number))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    server_number = Connections.get_server_number!(id)
    render(conn, "show.html", server_number: server_number)
  end

  def edit(conn, %{"id" => id}) do
    server_number = Connections.get_server_number!(id)
    changeset = Connections.change_server_number(server_number)
    render(conn, "edit.html", server_number: server_number, changeset: changeset)
  end

  def update(conn, %{"id" => id, "server_number" => server_number_params}) do
    server_number = Connections.get_server_number!(id)

    case Connections.update_server_number(server_number, server_number_params) do
      {:ok, server_number} ->
        conn
        |> put_flash(:info, "Server number updated successfully.")
        |> redirect(to: server_number_path(conn, :show, server_number))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", server_number: server_number, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    server_number = Connections.get_server_number!(id)
    {:ok, _server_number} = Connections.delete_server_number(server_number)

    conn
    |> put_flash(:info, "Server number deleted successfully.")
    |> redirect(to: server_number_path(conn, :index))
  end
end
