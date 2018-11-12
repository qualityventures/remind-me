defmodule RemindMe.Accounts do
  @moduledoc """
  The boundary for the Accounts system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Phauxth.Log
  alias RemindMe.{Accounts.User, Repo}

  def list_users do
    Repo.all(User)
  end

  def get(id), do: Repo.get(User, id)

  def get_by(%{"email" => email}) do
    Repo.get_by(User, email: email)
  end

  def get_by_phone(phone) do
    phone = format_phone(phone)
    Repo.get_by(User, phone: phone)
  end

  def create_user(attrs) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  def confirm_user(%User{} = user) do
    change(user, %{confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second)}) |> Repo.update()
  end

  def create_password_reset(endpoint, attrs) do
    with %User{} = user <- get_by(attrs) do
      change(user, %{reset_sent_at: DateTime.utc_now() |> DateTime.truncate(:second)}) |> Repo.update
      Log.info(%Log{user: user.id, message: "password reset requested"})
      Phauxth.Token.sign(endpoint, attrs)
    end
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def update_password(%User{} = user, attrs) do
    user
    |> User.create_changeset(attrs)
    |> change(%{reset_sent_at: nil, sessions: %{}})
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def list_sessions(user_id) do
    with user when is_map(user) <- Repo.get(User, user_id), do: user.sessions
  end

  def add_session(%User{sessions: sessions} = user, session_id, timestamp) do
    change(user, sessions: put_in(sessions, [session_id], timestamp))
    |> Repo.update
  end

  def delete_session(%User{sessions: sessions} = user, session_id) do
    change(user, sessions: Map.delete(sessions, session_id))
    |> Repo.update
  end

  def remove_old_sessions(session_age) do
    now = System.system_time(:second)
    Enum.map(
      list_users(),
      &(change(
          &1,
          sessions:
            :maps.filter(
              fn _, time ->
                time + session_age > now
              end,
              &1.sessions
            )
        )
        |> Repo.update())
    )
  end

  def format_phone(phone) do
    trimmed = String.trim_leading(phone, "1")
    bare = Regex.replace(~r{\D}, trimmed, "")
    {first, mid} = String.split_at(bare, 3)
    {mid, last} = String.split_at(mid, 3)

    "#{first}-#{mid}-#{last}"
  end
end
