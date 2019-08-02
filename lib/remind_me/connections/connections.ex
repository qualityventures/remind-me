defmodule RemindMe.Connections do
  @moduledoc false

  import Ecto.Query, warn: false

  alias RemindMe.Accounts
  alias RemindMe.Repo
  alias RemindMe.Connections.ClientNumber
  alias RemindMe.Connections.Connection
  alias RemindMe.Connections.Destination
  alias RemindMe.Connections.ServerNumber

  # Returns the list of all server_numbers.
  def list_server_numbers do
    Repo.all(ServerNumber)
  end

  # Gets a single server_number.
  # Raises `Ecto.NoResultsError` if the Server number does not exist.
  def get_server_number!(id), do: Repo.get!(ServerNumber, id)

  # Creates a server_number.
  def create_server_number(attrs \\ %{}) do
    %ServerNumber{}
    |> ServerNumber.changeset(attrs)
    |> Repo.insert()
  end

  # Updates a server_number.
  def update_server_number(%ServerNumber{} = server_number, attrs) do
    server_number
    |> ServerNumber.changeset(attrs)
    |> Repo.update()
  end

  # Deletes a ServerNumber.
  def delete_server_number(%ServerNumber{} = server_number) do
    Repo.delete(server_number)
  end

  # Returns an `%Ecto.Changeset{}` for tracking server_number changes.
  def change_server_number(%ServerNumber{} = server_number) do
    ServerNumber.changeset(server_number, %{})
  end

  # Gets the next available server number.
  # Returns {:ok, number} if successful or {:error, message} otherwise.
  def find_next_server_number(user) do
    user
    |> open_server_numbers()
    |> case do
      [] -> {:error, "All available \"To\" numbers are in use"}
      [n | _] -> {:ok, n}
    end
  end

  # Returns all server numbers not yet used by a user
  def open_server_numbers(user) do
    used =
      user
      |> Repo.preload(connections: :server_number)
      |> Map.get(:connections)
      |> Enum.map(fn c -> c |> Map.get(:server_number) |> Map.get(:number) end)

    list_server_numbers()
    |> Enum.filter(fn n -> !(n.number in used) end)
    |> Enum.sort(fn a, b -> a.id < b.id end)
  end

  # Returns the list of all connections.
  def list_connections do
    Repo.all(Connection)
  end

  # Returns a list of connections for the user.
  def list_connections_by_user(user) do
    query = from(c in Connection, where: c.user_id == ^user.id, select: c)

    Repo.all(query)
  end

  # Gets a single connection.
  # Raises `Ecto.NoResultsError` if the Connection does not exist.
  def get_connection!(id), do: Repo.get!(Connection, id)

  # Get connection with everything preloaded
  def get_connection_preloaded!(id) do
    Connection
    |> Repo.get!(id)
    |> Repo.preload([:user, :server_number, :destination, :client_number])
  end

  # Creates a connection.
  def create_connection(attrs \\ %{}) do
    %Connection{}
    |> Connection.changeset(attrs)
    |> Repo.insert()
  end

  # Updates a connection.
  def update_connection(%Connection{} = connection, attrs) do
    connection
    |> Connection.changeset(attrs)
    |> Repo.update()
  end

  # Deletes a Connection.
  def delete_connection(%Connection{} = connection) do
    Repo.delete(connection)
  end

  # Returns an `%Ecto.Changeset{}` for tracking connection changes.
  def change_connection(%Connection{} = connection) do
    Connection.changeset(connection, %{})
  end

  # Finds all connections with the given client number
  def find_connections_by_phone(phone) do
    phone = format_phone(phone)
    query = from(c in ClientNumber, where: c.number == ^phone, select: c)

    query
    |> Repo.all()
    |> Repo.preload(:connection)
    |> Enum.map(fn c ->
      c.connection
      |> Repo.preload([:server_number, :user, :client_number, :destination])
    end)
  end

  # Returns the list of all destinations.
  def list_destinations do
    Repo.all(Destination)
  end

  # Gets a single destination.
  # Raises `Ecto.NoResultsError` if the Destination does not exist.
  def get_destination!(id), do: Repo.get!(Destination, id)

  # Creates a destination.
  def create_destination(attrs \\ %{}) do
    %Destination{}
    |> Destination.changeset(attrs)
    |> Repo.insert()
  end

  # Updates a destination.
  def update_destination(%Destination{} = destination, attrs) do
    destination
    |> Destination.changeset(attrs)
    |> Repo.update()
  end

  # Deletes a Destination.
  def delete_destination(%Destination{} = destination) do
    Repo.delete(destination)
  end

  # Returns an `%Ecto.Changeset{}` for tracking destination changes.
  def change_destination(%Destination{} = destination) do
    Destination.changeset(destination, %{})
  end

  # Returns the list of all client_numbers.
  def list_client_numbers do
    Repo.all(ClientNumber)
  end

  # Gets a single client_number.
  # Raises `Ecto.NoResultsError` if the Client number does not exist.
  def get_client_number!(id), do: Repo.get!(ClientNumber, id)

  # Creates a client_number.
  def create_client_number(attrs \\ %{}) do
    %ClientNumber{}
    |> ClientNumber.changeset(attrs)
    |> Repo.insert()
  end

  # Updates a client_number.
  def update_client_number(%ClientNumber{} = client_number, attrs) do
    client_number
    |> ClientNumber.changeset(attrs)
    |> Repo.update()
  end

  # Deletes a ClientNumber.
  def delete_client_number(%ClientNumber{} = client_number) do
    Repo.delete(client_number)
  end

  # Returns an `%Ecto.Changeset{}` for tracking client_number changes.
  def change_client_number(%ClientNumber{} = client_number) do
    ClientNumber.changeset(client_number, %{})
  end

  # Makes sure that there isn't already the same client / server number match
  # and swaps the server number for another one if there is.
  def check_unique_server_number(attrs) do
    user = Accounts.get(attrs["user_id"])
    client = format_phone(attrs["client_number"]["number"])
    open_server_numbers = open_server_numbers(user)

    do_check_unique_server_number(open_server_numbers, client, attrs)
  end

  def do_check_unique_server_number([], _client, _attrs) do
    {:error, "Phone number has already been connected to all available 'text-to' numbers"}
  end

  def do_check_unique_server_number([server_number | tail], client, attrs) do
    connections =
      server_number
      |> Repo.preload(connections: :client_number)
      |> Map.get(:connections)

    connections
    |> Enum.filter(fn c -> c.client_number.number == client end)
    |> case do
      [] -> {:ok, Map.update!(attrs, "server_number_id", fn _ -> server_number.id end)}
      _ -> do_check_unique_server_number(tail, client, attrs)
    end
  end

  def format_phone(phone) do
    stripped =
      phone
      |> String.replace(~r{\D}, "")
      |> String.trim_leading("1")

    {first, mid} = String.split_at(stripped, 3)
    {mid, last} = String.split_at(mid, 3)

    "#{first}-#{mid}-#{last}"
  end
end
