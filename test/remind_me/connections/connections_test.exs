defmodule RemindMe.ConnectionsTest do
  use RemindMe.DataCase

  alias RemindMe.Connections

  describe "server_numbers" do
    alias RemindMe.Connections.ServerNumber

    @valid_attrs %{number: "some number"}
    @update_attrs %{number: "some updated number"}
    @invalid_attrs %{number: nil}

    def server_number_fixture(attrs \\ %{}) do
      {:ok, server_number} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Connections.create_server_number()

      server_number
    end

    test "list_server_numbers/0 returns all server_numbers" do
      server_number = server_number_fixture()
      assert Connections.list_server_numbers() == [server_number]
    end

    test "get_server_number!/1 returns the server_number with given id" do
      server_number = server_number_fixture()
      assert Connections.get_server_number!(server_number.id) == server_number
    end

    test "create_server_number/1 with valid data creates a server_number" do
      assert {:ok, %ServerNumber{} = server_number} =
               Connections.create_server_number(@valid_attrs)

      assert server_number.number == "some number"
    end

    test "create_server_number/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Connections.create_server_number(@invalid_attrs)
    end

    test "update_server_number/2 with valid data updates the server_number" do
      server_number = server_number_fixture()
      assert {:ok, server_number} = Connections.update_server_number(server_number, @update_attrs)
      assert %ServerNumber{} = server_number
      assert server_number.number == "some updated number"
    end

    test "update_server_number/2 with invalid data returns error changeset" do
      server_number = server_number_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Connections.update_server_number(server_number, @invalid_attrs)

      assert server_number == Connections.get_server_number!(server_number.id)
    end

    test "delete_server_number/1 deletes the server_number" do
      server_number = server_number_fixture()
      assert {:ok, %ServerNumber{}} = Connections.delete_server_number(server_number)
      assert_raise Ecto.NoResultsError, fn -> Connections.get_server_number!(server_number.id) end
    end

    test "change_server_number/1 returns a server_number changeset" do
      server_number = server_number_fixture()
      assert %Ecto.Changeset{} = Connections.change_server_number(server_number)
    end
  end

  describe "connections" do
    alias RemindMe.Connections.Connection

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def connection_fixture(attrs \\ %{}) do
      {:ok, connection} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Connections.create_connection()

      connection
    end

    test "list_connections/0 returns all connections" do
      connection = connection_fixture()
      assert Connections.list_connections() == [connection]
    end

    test "get_connection!/1 returns the connection with given id" do
      connection = connection_fixture()
      assert Connections.get_connection!(connection.id) == connection
    end

    test "create_connection/1 with valid data creates a connection" do
      assert {:ok, %Connection{} = connection} = Connections.create_connection(@valid_attrs)
    end

    test "create_connection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Connections.create_connection(@invalid_attrs)
    end

    test "update_connection/2 with valid data updates the connection" do
      connection = connection_fixture()
      assert {:ok, connection} = Connections.update_connection(connection, @update_attrs)
      assert %Connection{} = connection
    end

    test "update_connection/2 with invalid data returns error changeset" do
      connection = connection_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Connections.update_connection(connection, @invalid_attrs)

      assert connection == Connections.get_connection!(connection.id)
    end

    test "delete_connection/1 deletes the connection" do
      connection = connection_fixture()
      assert {:ok, %Connection{}} = Connections.delete_connection(connection)
      assert_raise Ecto.NoResultsError, fn -> Connections.get_connection!(connection.id) end
    end

    test "change_connection/1 returns a connection changeset" do
      connection = connection_fixture()
      assert %Ecto.Changeset{} = Connections.change_connection(connection)
    end
  end

  describe "destinations" do
    alias RemindMe.Connections.Destination

    @valid_attrs %{email: "some email", type: "some type"}
    @update_attrs %{email: "some updated email", type: "some updated type"}
    @invalid_attrs %{email: nil, type: nil}

    def destination_fixture(attrs \\ %{}) do
      {:ok, destination} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Connections.create_destination()

      destination
    end

    test "list_destinations/0 returns all destinations" do
      destination = destination_fixture()
      assert Connections.list_destinations() == [destination]
    end

    test "get_destination!/1 returns the destination with given id" do
      destination = destination_fixture()
      assert Connections.get_destination!(destination.id) == destination
    end

    test "create_destination/1 with valid data creates a destination" do
      assert {:ok, %Destination{} = destination} = Connections.create_destination(@valid_attrs)
      assert destination.email == "some email"
      assert destination.type == "some type"
    end

    test "create_destination/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Connections.create_destination(@invalid_attrs)
    end

    test "update_destination/2 with valid data updates the destination" do
      destination = destination_fixture()
      assert {:ok, destination} = Connections.update_destination(destination, @update_attrs)
      assert %Destination{} = destination
      assert destination.email == "some updated email"
      assert destination.type == "some updated type"
    end

    test "update_destination/2 with invalid data returns error changeset" do
      destination = destination_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Connections.update_destination(destination, @invalid_attrs)

      assert destination == Connections.get_destination!(destination.id)
    end

    test "delete_destination/1 deletes the destination" do
      destination = destination_fixture()
      assert {:ok, %Destination{}} = Connections.delete_destination(destination)
      assert_raise Ecto.NoResultsError, fn -> Connections.get_destination!(destination.id) end
    end

    test "change_destination/1 returns a destination changeset" do
      destination = destination_fixture()
      assert %Ecto.Changeset{} = Connections.change_destination(destination)
    end
  end

  describe "client_numbers" do
    alias RemindMe.Connections.ClientNumber

    @valid_attrs %{number: "some number"}
    @update_attrs %{number: "some updated number"}
    @invalid_attrs %{number: nil}

    def client_number_fixture(attrs \\ %{}) do
      {:ok, client_number} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Connections.create_client_number()

      client_number
    end

    test "list_client_numbers/0 returns all client_numbers" do
      client_number = client_number_fixture()
      assert Connections.list_client_numbers() == [client_number]
    end

    test "get_client_number!/1 returns the client_number with given id" do
      client_number = client_number_fixture()
      assert Connections.get_client_number!(client_number.id) == client_number
    end

    test "create_client_number/1 with valid data creates a client_number" do
      assert {:ok, %ClientNumber{} = client_number} =
               Connections.create_client_number(@valid_attrs)

      assert client_number.number == "some number"
    end

    test "create_client_number/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Connections.create_client_number(@invalid_attrs)
    end

    test "update_client_number/2 with valid data updates the client_number" do
      client_number = client_number_fixture()
      assert {:ok, client_number} = Connections.update_client_number(client_number, @update_attrs)
      assert %ClientNumber{} = client_number
      assert client_number.number == "some updated number"
    end

    test "update_client_number/2 with invalid data returns error changeset" do
      client_number = client_number_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Connections.update_client_number(client_number, @invalid_attrs)

      assert client_number == Connections.get_client_number!(client_number.id)
    end

    test "delete_client_number/1 deletes the client_number" do
      client_number = client_number_fixture()
      assert {:ok, %ClientNumber{}} = Connections.delete_client_number(client_number)
      assert_raise Ecto.NoResultsError, fn -> Connections.get_client_number!(client_number.id) end
    end

    test "change_client_number/1 returns a client_number changeset" do
      client_number = client_number_fixture()
      assert %Ecto.Changeset{} = Connections.change_client_number(client_number)
    end
  end
end
