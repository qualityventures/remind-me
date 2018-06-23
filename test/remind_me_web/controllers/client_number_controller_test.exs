defmodule RemindMeWeb.ClientNumberControllerTest do
  use RemindMeWeb.ConnCase

  alias RemindMe.Connections

  @create_attrs %{number: "some number"}
  @update_attrs %{number: "some updated number"}
  @invalid_attrs %{number: nil}

  def fixture(:client_number) do
    {:ok, client_number} = Connections.create_client_number(@create_attrs)
    client_number
  end

  describe "index" do
    test "lists all client_numbers", %{conn: conn} do
      conn = get conn, client_number_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Client numbers"
    end
  end

  describe "new client_number" do
    test "renders form", %{conn: conn} do
      conn = get conn, client_number_path(conn, :new)
      assert html_response(conn, 200) =~ "New Client number"
    end
  end

  describe "create client_number" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, client_number_path(conn, :create), client_number: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == client_number_path(conn, :show, id)

      conn = get conn, client_number_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Client number"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, client_number_path(conn, :create), client_number: @invalid_attrs
      assert html_response(conn, 200) =~ "New Client number"
    end
  end

  describe "edit client_number" do
    setup [:create_client_number]

    test "renders form for editing chosen client_number", %{conn: conn, client_number: client_number} do
      conn = get conn, client_number_path(conn, :edit, client_number)
      assert html_response(conn, 200) =~ "Edit Client number"
    end
  end

  describe "update client_number" do
    setup [:create_client_number]

    test "redirects when data is valid", %{conn: conn, client_number: client_number} do
      conn = put conn, client_number_path(conn, :update, client_number), client_number: @update_attrs
      assert redirected_to(conn) == client_number_path(conn, :show, client_number)

      conn = get conn, client_number_path(conn, :show, client_number)
      assert html_response(conn, 200) =~ "some updated number"
    end

    test "renders errors when data is invalid", %{conn: conn, client_number: client_number} do
      conn = put conn, client_number_path(conn, :update, client_number), client_number: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Client number"
    end
  end

  describe "delete client_number" do
    setup [:create_client_number]

    test "deletes chosen client_number", %{conn: conn, client_number: client_number} do
      conn = delete conn, client_number_path(conn, :delete, client_number)
      assert redirected_to(conn) == client_number_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, client_number_path(conn, :show, client_number)
      end
    end
  end

  defp create_client_number(_) do
    client_number = fixture(:client_number)
    {:ok, client_number: client_number}
  end
end
