defmodule RemindMeWeb.ConnectionControllerTest do
  use RemindMeWeb.ConnCase

  alias RemindMe.Connections

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:connection) do
    {:ok, connection} = Connections.create_connection(@create_attrs)
    connection
  end

  describe "index" do
    test "lists all connections", %{conn: conn} do
      conn = get conn, connection_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Connections"
    end
  end

  describe "new connection" do
    test "renders form", %{conn: conn} do
      conn = get conn, connection_path(conn, :new)
      assert html_response(conn, 200) =~ "New Connection"
    end
  end

  describe "create connection" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, connection_path(conn, :create), connection: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == connection_path(conn, :show, id)

      conn = get conn, connection_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Connection"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, connection_path(conn, :create), connection: @invalid_attrs
      assert html_response(conn, 200) =~ "New Connection"
    end
  end

  describe "edit connection" do
    setup [:create_connection]

    test "renders form for editing chosen connection", %{conn: conn, connection: connection} do
      conn = get conn, connection_path(conn, :edit, connection)
      assert html_response(conn, 200) =~ "Edit Connection"
    end
  end

  describe "update connection" do
    setup [:create_connection]

    test "redirects when data is valid", %{conn: conn, connection: connection} do
      conn = put conn, connection_path(conn, :update, connection), connection: @update_attrs
      assert redirected_to(conn) == connection_path(conn, :show, connection)

      conn = get conn, connection_path(conn, :show, connection)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, connection: connection} do
      conn = put conn, connection_path(conn, :update, connection), connection: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Connection"
    end
  end

  describe "delete connection" do
    setup [:create_connection]

    test "deletes chosen connection", %{conn: conn, connection: connection} do
      conn = delete conn, connection_path(conn, :delete, connection)
      assert redirected_to(conn) == connection_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, connection_path(conn, :show, connection)
      end
    end
  end

  defp create_connection(_) do
    connection = fixture(:connection)
    {:ok, connection: connection}
  end
end
