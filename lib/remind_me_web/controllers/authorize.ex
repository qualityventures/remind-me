defmodule RemindMeWeb.Authorize do
  import Plug.Conn
  import Phoenix.Controller
  alias RemindMeWeb.Router.Helpers, as: Routes

  # This function can be used to customize the `action` function in
  # the controller so that only authenticated users can access each route.
  # See the [Authorization wiki page](https://github.com/riverrun/phauxth/wiki/Authorization)
  # for more information and examples.
  def auth_action(%Plug.Conn{assigns: %{current_user: nil}} = conn, _) do
    need_login(conn)
  end

  def auth_action(
        %Plug.Conn{assigns: %{current_user: current_user}, params: params} = conn,
        module
      ) do
    apply(module, action_name(conn), [conn, params, current_user])
  end

  # Plug to only allow authenticated users to access the resource.
  # See the user controller for an example.
  def user_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    need_login(conn)
  end

  def user_check(conn, _opts), do: conn

  # Plug to only allow unauthenticated users to access the resource.
  # See the session controller for an example.
  def guest_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts), do: conn

  def guest_check(%Plug.Conn{assigns: %{current_user: _current_user}} = conn, _opts) do
    error(conn, "", Routes.home_path(conn, :dashboard))
  end

  # Plug to only allow authenticated users with the correct id to access the resource.
  # See the user controller for an example.
  def id_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    need_login(conn)
  end

  def id_check(
        %Plug.Conn{params: %{"id" => id}, assigns: %{current_user: current_user}} = conn,
        _opts
      ) do
    (id == to_string(current_user.id) and conn) || error(conn, "", Routes.home_path(conn, :index))
  end

  def owner_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    need_login(conn)
  end

  def owner_check(%Plug.Conn{assigns: %{current_user: current_user}} = conn, user) do
    user == current_user || error(conn, "", Routes.home_path(conn, :index))
  end

  # Plug to only allow admins access to the resource
  def admin_check(
        %Plug.Conn{assigns: %{current_user: %{email: "damonvjanis@gmail.com"}}} = conn,
        _opts
      ) do
    conn
  end

  def admin_check(conn, _opts), do: need_login(conn)

  def success(conn, message, path) do
    conn
    |> put_flash(:info, message)
    |> redirect(to: path)
  end

  def error(conn, message, path) do
    conn
    |> put_flash(:error, message)
    |> redirect(to: path)
    |> halt
  end

  def login_success(conn, path) do
    path = get_session(conn, :request_path) || path

    delete_session(conn, :request_path)
    |> success("You have been logged in", get_session(conn, :request_path) || path)
  end

  defp need_login(conn) do
    conn
    |> put_session(:request_path, current_path(conn))
    |> put_flash(:error, "You need to log in to view this page")
    |> redirect(to: Routes.session_path(conn, :new))
    |> halt()
  end
end
