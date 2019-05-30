defmodule RemindMeWeb.PasswordResetController do
  use RemindMeWeb, :controller

  import RemindMeWeb.Authorize
  alias RemindMe.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"password_reset" => %{"email" => email}}) do
    email = String.downcase(email)
    key = Accounts.create_password_reset(RemindMeWeb.Endpoint, %{"email" => email})
    Accounts.Message.reset_request(email, key)
    message = "Check your inbox for instructions on how to reset your password"
    success(conn, message, Routes.home_path(conn, :index))
  end

  def edit(conn, %{"key" => key}) do
    render(conn, "edit.html", key: key)
  end

  def edit(conn, _params) do
    render(conn, RemindMeWeb.ErrorView.render("404.html"))
  end

  def update(conn, %{"password_reset" => params}) do
    case Phauxth.Confirm.verify(params, Accounts, mode: :pass_reset) do
      {:ok, user} ->
        Accounts.update_password(user, params) |> update_password(conn, params)

      {:error, message} ->
        put_flash(conn, :error, message)
        |> render("edit.html", key: params["key"])
    end
  end

  defp update_password({:ok, user}, conn, _params) do
    Accounts.Message.reset_success(user.email)
    message = "Your password has been reset"

    delete_session(conn, :phauxth_session_id)
    |> success(message, Routes.session_path(conn, :new))
  end

  defp update_password({:error, %Ecto.Changeset{} = changeset}, conn, params) do
    message = with p <- changeset.errors[:password], do: elem(p, 0)

    put_flash(conn, :error, message || "Invalid input")
    |> render("edit.html", key: params["key"])
  end
end
