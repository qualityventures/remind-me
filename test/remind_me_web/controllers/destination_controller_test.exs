defmodule RemindMeWeb.DestinationControllerTest do
  use RemindMeWeb.ConnCase

  alias RemindMe.Connections

  @create_attrs %{email: "some email", type: "some type"}
  @update_attrs %{email: "some updated email", type: "some updated type"}
  @invalid_attrs %{email: nil, type: nil}

  def fixture(:destination) do
    {:ok, destination} = Connections.create_destination(@create_attrs)
    destination
  end

  describe "index" do
    test "lists all destinations", %{conn: conn} do
      conn = get conn, destination_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Destinations"
    end
  end

  describe "new destination" do
    test "renders form", %{conn: conn} do
      conn = get conn, destination_path(conn, :new)
      assert html_response(conn, 200) =~ "New Destination"
    end
  end

  describe "create destination" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, destination_path(conn, :create), destination: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == destination_path(conn, :show, id)

      conn = get conn, destination_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Destination"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, destination_path(conn, :create), destination: @invalid_attrs
      assert html_response(conn, 200) =~ "New Destination"
    end
  end

  describe "edit destination" do
    setup [:create_destination]

    test "renders form for editing chosen destination", %{conn: conn, destination: destination} do
      conn = get conn, destination_path(conn, :edit, destination)
      assert html_response(conn, 200) =~ "Edit Destination"
    end
  end

  describe "update destination" do
    setup [:create_destination]

    test "redirects when data is valid", %{conn: conn, destination: destination} do
      conn = put conn, destination_path(conn, :update, destination), destination: @update_attrs
      assert redirected_to(conn) == destination_path(conn, :show, destination)

      conn = get conn, destination_path(conn, :show, destination)
      assert html_response(conn, 200) =~ "some updated email"
    end

    test "renders errors when data is invalid", %{conn: conn, destination: destination} do
      conn = put conn, destination_path(conn, :update, destination), destination: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Destination"
    end
  end

  describe "delete destination" do
    setup [:create_destination]

    test "deletes chosen destination", %{conn: conn, destination: destination} do
      conn = delete conn, destination_path(conn, :delete, destination)
      assert redirected_to(conn) == destination_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, destination_path(conn, :show, destination)
      end
    end
  end

  defp create_destination(_) do
    destination = fixture(:destination)
    {:ok, destination: destination}
  end
end
