defmodule RemindMeWeb.DestinationController do
  use RemindMeWeb, :controller

  alias RemindMe.Connections
  alias RemindMe.Connections.Destination

  import RemindMeWeb.Authorize

  plug(:admin_check)

  def index(conn, _params) do
    destinations = Connections.list_destinations()
    render(conn, "index.html", destinations: destinations)
  end

  def new(conn, _params) do
    changeset = Connections.change_destination(%Destination{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"destination" => destination_params}) do
    case Connections.create_destination(destination_params) do
      {:ok, destination} ->
        conn
        |> put_flash(:info, "Destination created successfully.")
        |> redirect(to: destination_path(conn, :show, destination))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    destination = Connections.get_destination!(id)
    render(conn, "show.html", destination: destination)
  end

  def edit(conn, %{"id" => id}) do
    destination = Connections.get_destination!(id)
    changeset = Connections.change_destination(destination)
    render(conn, "edit.html", destination: destination, changeset: changeset)
  end

  def update(conn, %{"id" => id, "destination" => destination_params}) do
    destination = Connections.get_destination!(id)

    case Connections.update_destination(destination, destination_params) do
      {:ok, destination} ->
        conn
        |> put_flash(:info, "Destination updated successfully.")
        |> redirect(to: destination_path(conn, :show, destination))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", destination: destination, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    destination = Connections.get_destination!(id)
    {:ok, _destination} = Connections.delete_destination(destination)

    conn
    |> put_flash(:info, "Destination deleted successfully.")
    |> redirect(to: destination_path(conn, :index))
  end
end
