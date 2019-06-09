defmodule RemindMeWeb.ServerNumberControllerTest do
  use RemindMeWeb.ConnCase

  alias RemindMe.Connections

  @create_attrs %{number: "some number"}
  @update_attrs %{number: "some updated number"}
  @invalid_attrs %{number: nil}

  def fixture(:server_number) do
    {:ok, server_number} = Connections.create_server_number(@create_attrs)
    server_number
  end

  describe "index" do
    test "lists all server_numbers", %{conn: conn} do
      conn = get(conn, Routes.server_number_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Server numbers"
    end
  end

  describe "new server_number" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.server_number_path(conn, :new))
      assert html_response(conn, 200) =~ "New Server number"
    end
  end

  describe "create server_number" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.server_number_path(conn, :create), server_number: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.server_number_path(conn, :show, id)

      conn = get(conn, Routes.server_number_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Server number"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.server_number_path(conn, :create), server_number: @invalid_attrs
      assert html_response(conn, 200) =~ "New Server number"
    end
  end

  describe "edit server_number" do
    setup [:create_server_number]

    test "renders form for editing chosen server_number", %{
      conn: conn,
      server_number: server_number
    } do
      conn = get(conn, Routes.server_number_path(conn, :edit, server_number))
      assert html_response(conn, 200) =~ "Edit Server number"
    end
  end

  describe "update server_number" do
    setup [:create_server_number]

    test "redirects when data is valid", %{conn: conn, server_number: server_number} do
      conn =
        put conn, Routes.server_number_path(conn, :update, server_number),
          server_number: @update_attrs

      assert redirected_to(conn) == Routes.server_number_path(conn, :show, server_number)

      conn = get(conn, Routes.server_number_path(conn, :show, server_number))
      assert html_response(conn, 200) =~ "some updated number"
    end

    test "renders errors when data is invalid", %{conn: conn, server_number: server_number} do
      conn =
        put conn, Routes.server_number_path(conn, :update, server_number),
          server_number: @invalid_attrs

      assert html_response(conn, 200) =~ "Edit Server number"
    end
  end

  describe "delete server_number" do
    setup [:create_server_number]

    test "deletes chosen server_number", %{conn: conn, server_number: server_number} do
      conn = delete(conn, Routes.server_number_path(conn, :delete, server_number))
      assert redirected_to(conn) == Routes.server_number_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.server_number_path(conn, :show, server_number))
      end
    end
  end

  defp create_server_number(_) do
    server_number = fixture(:server_number)
    {:ok, server_number: server_number}
  end
end
