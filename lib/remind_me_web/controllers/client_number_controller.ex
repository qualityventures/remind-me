defmodule RemindMeWeb.ClientNumberController do
  use RemindMeWeb, :controller

  alias RemindMe.Connections
  alias RemindMe.Connections.ClientNumber

  import RemindMeWeb.Authorize

  plug(:admin_check)

  def index(conn, _params) do
    client_numbers = Connections.list_client_numbers()
    render(conn, "index.html", client_numbers: client_numbers)
  end

  def new(conn, _params) do
    changeset = Connections.change_client_number(%ClientNumber{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"client_number" => client_number_params}) do
    case Connections.create_client_number(client_number_params) do
      {:ok, client_number} ->
        conn
        |> put_flash(:info, "Client number created successfully.")
        |> redirect(to: client_number_path(conn, :show, client_number))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    client_number = Connections.get_client_number!(id)
    render(conn, "show.html", client_number: client_number)
  end

  def edit(conn, %{"id" => id}) do
    client_number = Connections.get_client_number!(id)
    changeset = Connections.change_client_number(client_number)
    render(conn, "edit.html", client_number: client_number, changeset: changeset)
  end

  def update(conn, %{"id" => id, "client_number" => client_number_params}) do
    client_number = Connections.get_client_number!(id)

    case Connections.update_client_number(client_number, client_number_params) do
      {:ok, client_number} ->
        conn
        |> put_flash(:info, "Client number updated successfully.")
        |> redirect(to: client_number_path(conn, :show, client_number))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", client_number: client_number, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    client_number = Connections.get_client_number!(id)
    {:ok, _client_number} = Connections.delete_client_number(client_number)

    conn
    |> put_flash(:info, "Client number deleted successfully.")
    |> redirect(to: client_number_path(conn, :index))
  end
end
