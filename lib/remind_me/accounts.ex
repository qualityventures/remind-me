defmodule RemindMe.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias RemindMe.{Accounts.User, Repo, Sessions, Sessions.Session, Connections}

  def list_users, do: Repo.all(User)

  def get(id), do: Repo.get(User, id)

  def get_user(id), do: Repo.get(User, id)

  def get_by(%{"session_id" => session_id}) do
    with %Session{user_id: user_id} <- Sessions.get_session(session_id),
         do: get_user(user_id)
  end

  def get_by(%{"email" => email}) do
    Repo.get_by(User, email: email)
  end

  def get_by(%{"user_id" => user_id}), do: Repo.get(User, user_id)

  def get_by_phone(phone) do
    phone = Connections.format_phone(phone)
    Repo.get_by(User, phone: phone)
  end

  def create_user(attrs) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  def confirm_user(%User{} = user) do
    user
    |> User.confirm_changeset(DateTime.truncate(DateTime.utc_now(), :second))
    |> Repo.update()
  end

  def create_password_reset(attrs) do
    with %User{} = user <- get_by(attrs) do
      user
      |> User.password_reset_changeset(DateTime.truncate(DateTime.utc_now(), :second))
      |> Repo.update()
    end
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def update_password(%User{} = user, attrs) do
    Sessions.delete_user_sessions(user)

    user
    |> User.update_password_changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
