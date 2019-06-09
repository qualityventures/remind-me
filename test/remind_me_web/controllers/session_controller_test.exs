defmodule RemindMeWeb.SessionControllerTest do
  use RemindMeWeb.ConnCase

  import RemindMeWeb.AuthTestHelpers

  @create_attrs %{
    email: "robin@example.com",
    password: "reallyHard2gue$$",
    phone: "1234567890",
    first: "Damon",
    last: "Janis"
  }
  @invalid_attrs %{email: "robin@example.com", password: "cannotGue$$it"}
  @unconfirmed_attrs %{email: "lancelot@example.com", password: "reallyHard2gue$$"}
  @rem_attrs %{email: "robin@example.com", password: "reallyHard2gue$$", remember_me: "true", first: "Damon", last: "Janis"}
  @no_rem_attrs Map.merge(@rem_attrs, %{remember_me: "false"})

  setup %{conn: conn} do
    conn = conn |> bypass_through(RemindMeWeb.Router, [:browser]) |> get("/")
    user = add_user_confirmed(@create_attrs)
    {:ok, %{conn: conn, user: user}}
  end

  describe "login form" do
    test "rendering login form fails for user that is already logged in", %{
      conn: conn,
      user: user
    } do
      conn = conn |> add_session(user) |> send_resp(:ok, "/")
      conn = get(conn, Routes.session_path(conn, :new))
      assert redirected_to(conn) == Routes.home_path(conn, :dashboard)
    end
  end

  describe "create session" do
    test "login succeeds", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), session: @create_attrs)
      assert redirected_to(conn) == Routes.home_path(conn, :index)
    end

    test "login fails for user that is not yet confirmed", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), session: @unconfirmed_attrs)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "login fails for user that is already logged in", %{conn: conn, user: user} do
      conn = conn |> add_session(user) |> send_resp(:ok, "/")
      conn = post(conn, Routes.session_path(conn, :create), session: @create_attrs)
      assert redirected_to(conn) == Routes.home_path(conn, :dashboard)
    end

    test "login fails for invalid password", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), session: @invalid_attrs)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "redirects to previously requested resource", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :show, user))
      assert redirected_to(conn) == Routes.session_path(conn, :new)
      conn = post(conn, Routes.session_path(conn, :create), session: @create_attrs)
      assert redirected_to(conn) == Routes.user_path(conn, :show, user)
    end

    test "remember me cookie is added / not added", %{conn: conn} do
      rem_conn = post(conn, Routes.session_path(conn, :create), session: @rem_attrs)
      assert rem_conn.resp_cookies["remember_me"]
      no_rem_conn = post(conn, Routes.session_path(conn, :create), session: @no_rem_attrs)
      refute no_rem_conn.resp_cookies["remember_me"]
    end
  end

  describe "delete session" do
    test "logout succeeds and session is deleted", %{conn: conn, user: user} do
      conn = conn |> add_session(user) |> send_resp(:ok, "/")
      session_id = get_session(conn, :phauxth_session_id)
      conn = delete(conn, Routes.session_path(conn, :delete, session_id))
      assert redirected_to(conn) == Routes.home_path(conn, :index)
      conn = get(conn, Routes.user_path(conn, :index))
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end
  end
end
