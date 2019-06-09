defmodule RemindMeWeb.UserControllerTest do
  use RemindMeWeb.ConnCase

  import RemindMeWeb.AuthTestHelpers

  alias RemindMe.Accounts

  @create_attrs %{
    email: "bill@example.com",
    password: "reallyHard2gue$$",
    phone: "1234567890",
    first: "Damon",
    last: "Janis"
  }
  @update_attrs %{email: "william@example.com"}
  @invalid_attrs %{@create_attrs | email: "invalid_email"}

  setup %{conn: conn} do
    conn = conn |> bypass_through(RemindMeWeb.Router, [:browser]) |> get("/")
    {:ok, %{conn: conn}}
  end

  describe "index" do
    test "redirected", %{conn: conn} do
      user = add_user(%{@create_attrs | email: "reg@example.com"})
      conn = conn |> add_session(user) |> send_resp(:ok, "/")
      conn = get(conn, Routes.user_path(conn, :index))
      assert html_response(conn, 302)
    end

    test "renders /users error for nil user", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end
  end

  describe "renders forms" do
    setup [:add_user_session]

    test "rendirected", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))
      assert html_response(conn, 302)
    end

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :edit, user))
      assert html_response(conn, 200) =~ "Timezone"
    end
  end

  describe "show user resource" do
    setup [:add_user_session]

    test "redirected away", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :show, user))
      assert html_response(conn, 302)
    end
  end

  describe "create user" do
    test "creates user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "does not create user and renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200)
    end
  end

  describe "updates user" do
    setup [:add_user_session]

    test "updates chosen user when data is valid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert redirected_to(conn) == Routes.home_path(conn, :index)
      updated_user = Accounts.get_user(user.id)
      assert updated_user.email == "william@example.com"
    end

    test "does not update chosen user and renders errors when data is invalid", %{
      conn: conn,
      user: user
    } do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Timezone"
    end
  end

  describe "delete user" do
    setup [:add_user_session]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert redirected_to(conn) == Routes.session_path(conn, :new)
      refute Accounts.get_user(user.id)
    end

    test "cannot delete other user", %{conn: conn, user: user} do
      other = add_user(%{@create_attrs | email: "tony@example.com"})
      conn = delete(conn, Routes.user_path(conn, :delete, other))
      assert redirected_to(conn) == Routes.home_path(conn, :index)
      assert Accounts.get_user(other.id)
    end
  end

  defp add_user_session(%{conn: conn}) do
    user = add_user(%{@create_attrs | email: "reg@example.com"})
    conn = conn |> add_session(user) |> send_resp(:ok, "/")
    {:ok, %{conn: conn, user: user}}
  end
end
