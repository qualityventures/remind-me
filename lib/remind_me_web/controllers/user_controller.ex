defmodule RemindMeWeb.UserController do
  use RemindMeWeb, :controller

  import RemindMeWeb.Authorize

  alias Phauxth.Log
  alias RemindMe.Connections
  alias RemindMe.Accounts

  plug(:admin_check when action in [:index, :show])
  plug(:guest_check when action in [:new, :create])
  plug(:id_check when action in [:edit, :update, :delete])

  def index(conn, _) do
    users = Accounts.list_users()

    render(conn, "index.html", users: users)
  end

  def new(conn, _) do
    changeset = Accounts.change_user(%Accounts.User{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => %{"email" => email} = user_params}) do
    key = Phauxth.Token.sign(conn, %{"email" => email})

    case Accounts.create_user(user_params) do
      {:ok, user} ->
        # Get available server number to create connection with
        {:ok, server_number} = Connections.find_next_server_number(user)

        Log.info(%Log{user: user.id, message: "user created"})
        Accounts.Message.confirm_request(email, key)
        Connections.create_connection(%{
          "user_id" => user.id,
          "server_number_id" => server_number.id,
          "client_number" => %{"number" => user.phone},
          "destination" => %{"email" => user.email, "type" => "email"}
        })

        success(
          conn,
          "Please click link in confirmation email, then log in below",
          Routes.session_path(conn, :new)
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    user = (id == to_string(user.id) and user) || Accounts.get(id)
    render(conn, "show.html", user: user)
  end

  def edit(%Plug.Conn{assigns: %{current_user: user}} = conn, _) do
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"user" => user_params}) do
    case Accounts.update_user(user, user_params) do
      {:ok, _user} ->
        success(conn, "Settings updated successfully", Routes.home_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(%Plug.Conn{assigns: %{current_user: user}} = conn, _) do
    {:ok, _user} = Accounts.delete_user(user)

    delete_session(conn, :phauxth_session_id)
    |> success("Account deleted successfully", Routes.session_path(conn, :new))
  end
end
