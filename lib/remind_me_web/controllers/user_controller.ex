defmodule RemindMeWeb.UserController do
  use RemindMeWeb, :controller

  import RemindMeWeb.Authorize
  alias Phauxth.Log
  alias RemindMe.Accounts

  # the following plugs are defined in the controllers/authorize.ex file
  plug(:user_check when action in [:index, :show])
  plug(:id_check when action in [:edit, :update, :delete])
  plug(:guest_check when action in [:new])

  # def index(conn, _) do
  #   users = Accounts.list_users()
  #   render(conn, "index.html", users: users)
  # end

  def new(conn, _) do
    changeset = Accounts.change_user(%Accounts.User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => %{"email" => email} = user_params}) do
    key = Phauxth.Token.sign(conn, %{"email" => email})

    case Accounts.create_user(user_params) do
      {:ok, user} ->
        Log.info(%Log{user: user.id, message: "user created"})
        Accounts.Message.confirm_request(email, key)

        success(
          conn,
          "Please click link in confirmation email, then log in below",
          session_path(conn, :new)
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  # def show(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id" => id}) do
  #   user = (id == to_string(user.id) and user) || Accounts.get(id)
  #   render(conn, "show.html", user: user)
  # end

  def edit(%Plug.Conn{assigns: %{current_user: user}} = conn, _) do
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"user" => user_params}) do
    case Accounts.update_user(user, user_params) do
      {:ok, _user} ->
        success(conn, "Settings updated successfully", home_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(%Plug.Conn{assigns: %{current_user: user}} = conn, _) do
    {:ok, _user} = Accounts.delete_user(user)

    delete_session(conn, :phauxth_session_id)
    |> success("Account deleted successfully", session_path(conn, :new))
  end
end
