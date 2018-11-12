defmodule RemindMeWeb.ConfirmController do
  use RemindMeWeb, :controller

  import RemindMeWeb.Authorize
  alias RemindMe.Accounts

  def index(conn, params) do
    # Set expiration for confirmation email to one week
    case Phauxth.Confirm.verify(params, Accounts, max_age: 60 * 60 * 24 * 7) do
      {:ok, user} ->
        Accounts.confirm_user(user)
        message = "Your account has been confirmed"
        Accounts.Message.confirm_success(user.email)
        success(conn, message, Routes.session_path(conn, :new))

      {:error, message} ->
        error(conn, message, Routes.session_path(conn, :new))
    end
  end
end
