defmodule RemindMeWeb.ConnectionController do
  use RemindMeWeb, :controller

  import RemindMeWeb.Authorize

  alias RemindMe.Connections
  alias RemindMe.Connections.ClientNumber
  alias RemindMe.Connections.Connection
  alias RemindMe.Connections.Destination

  plug(:user_check)

  def index(conn, _params) do
    user = conn.assigns.current_user
    connections = Connections.list_connections_by_user(user)
    connections = Enum.map(connections, fn c -> Connections.get_connection_preloaded!(c.id) end)
    render(conn, "index.html", connections: connections)
  end

  def new(conn, _params) do
    user = conn.assigns.current_user

    case Connections.find_next_server_number(user) do
      {:ok, number} ->
        connection = %Connection{client_number: %ClientNumber{}, destination: %Destination{}}
        changeset = Connections.change_connection(connection)
        action = Routes.connection_path(conn, :create)
        assigns = [server_number: number, user: user, changeset: changeset, action: action]

        render(conn, "new.html", assigns)

      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: Routes.connection_path(conn, :index))
    end
  end

  def create(conn, %{"connection" => connection_params}) do
    return = Connections.create_connection(connection_params)

    case return do
      {:ok, connection} ->
        conn
        |> put_flash(:info, "Connection created successfully.")
        |> redirect(to: Routes.connection_path(conn, :show, connection))

      {:error, %Ecto.Changeset{} = changeset} ->
        user = conn.assigns.current_user
        {:ok, number} = Connections.find_next_server_number(user)
        action = Routes.connection_path(conn, :create)
        assigns = [server_number: number, user: user, changeset: changeset, action: action]

        conn
        |> put_flash(:error, "Please check the errors below:")
        |> render("new.html", assigns)
    end
  end

  def show(conn, %{"id" => id}) do
    connection = Connections.get_connection_preloaded!(id)

    if connection.user.id == conn.assigns.current_user.id do
      render(conn, "show.html", connection: connection)
    else
      redirect(conn, to: Routes.connection_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    connection = Connections.get_connection_preloaded!(id)
    changeset = Connections.change_connection(connection)
    action = Routes.connection_path(conn, :update, connection)

    if connection.user.id == conn.assigns.current_user.id do
      assigns = [
        connection: connection,
        changeset: changeset,
        action: action,
        server_number: connection.server_number,
        user: user
      ]

      render(conn, "edit.html", assigns)
    else
      redirect(conn, to: Routes.connection_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "connection" => connection_params}) do
    connection = Connections.get_connection_preloaded!(id)

    if connection.user.id == conn.assigns.current_user.id do
      case Connections.update_connection(connection, connection_params) do
        {:ok, connection} ->
          conn
          |> put_flash(:info, "Connection updated successfully.")
          |> redirect(to: Routes.connection_path(conn, :show, connection))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", connection: connection, changeset: changeset)
      end
    else
      redirect(conn, to: Routes.connection_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => id}) do
    connection = Connections.get_connection_preloaded!(id)

    if connection.user.id == conn.assigns.current_user.id do
      {:ok, _connection} = Connections.delete_connection(connection)

      conn
      |> put_flash(:info, "Connection deleted successfully.")
      |> redirect(to: Routes.connection_path(conn, :index))
    else
      redirect(conn, to: Routes.connection_path(conn, :index))
    end
  end
end
