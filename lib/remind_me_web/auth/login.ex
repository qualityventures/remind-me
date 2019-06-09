defmodule RemindMeWeb.Auth.Login do
  @moduledoc """
  Custom login module that checks if the user is confirmed before
  allowing the user to log in.
  """

  use Phauxth.Login.Base

  alias RemindMe.Accounts

  def authenticate(%{"password" => password} = params, _, opts) do
    case Accounts.get_by(params) do
      nil -> {:error, "no user found"}
      %{confirmed_at: nil} -> {:error, "account unconfirmed"}
      user -> check_pass(user, password, opts)
    end
  end

  # If the user still has a Bcrypt password hash, replace it with an Argon2 hash
  defp check_pass(user, password, opts) do
    case user.password_hash do
      "$2b$" <> _ -> replace_with_argon2(Bcrypt.check_pass(user, password, opts), password)
      "$argon2" <> _ -> Argon2.check_pass(user, password, opts)
    end
  end

  defp replace_with_argon2({:ok, user}, password) do
    Accounts.update_password(user, %{password: password})
  end
end
