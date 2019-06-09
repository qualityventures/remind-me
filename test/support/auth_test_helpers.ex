defmodule RemindMeWeb.AuthTestHelpers do
  use Phoenix.ConnTest

  import Ecto.Changeset

  alias RemindMe.{Accounts, Repo, Sessions}
  alias RemindMeWeb.Auth.Token

  def add_user(attrs) do
    {:ok, user} = Accounts.create_user(attrs)
    user
  end

  def gen_key(email), do: Token.sign(%{"email" => email})

  def add_user_confirmed(attrs) do
    attrs
    |> add_user()
    |> change(%{confirmed_at: now()})
    |> Repo.update!()
  end

  def add_reset_user(attrs) do
    attrs
    |> add_user()
    |> change(%{confirmed_at: now()})
    |> change(%{reset_sent_at: now()})
    |> Repo.update!()
  end

  def add_session(conn, user) do
    {:ok, %{id: session_id}} = Sessions.create_session(%{user_id: user.id})

    conn
    |> put_session(:phauxth_session_id, session_id)
    |> configure_session(renew: true)
  end

  defp now do
    DateTime.utc_now() |> DateTime.truncate(:second)
  end
end
