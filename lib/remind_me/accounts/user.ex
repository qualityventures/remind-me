defmodule RemindMe.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias RemindMe.Accounts.User

  schema "users" do
    field(:first, :string)
    field(:last, :string)
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    field(:phone, :string)
    field(:confirmed_at, :utc_datetime)
    field(:reset_sent_at, :utc_datetime)
    field(:timezone, :string, default: "US/Eastern")

    has_many :sessions, RemindMe.Sessions.Session, on_delete: :delete_all
    has_many(:connections, RemindMe.Connections.Connection)
    has_many(:messages, RemindMe.Messages.Message)
    has_many(:events, RemindMe.Events.Event)

    timestamps()
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:first, :last, :email, :phone, :timezone])
    |> validate_required([:first, :last, :email, :phone])
    |> unique_email
  end

  def create_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:first, :last, :email, :phone, :password])
    |> validate_required([:first, :last, :email, :phone, :password])
    |> unique_email
    |> validate_password(:password)
    |> put_pass_hash
  end

  def confirm_changeset(%__MODULE__{} = user, confirmed_at) do
    change(user, %{confirmed_at: confirmed_at})
  end

  def password_reset_changeset(%__MODULE__{} = user, reset_sent_at) do
    change(user, %{reset_sent_at: reset_sent_at})
  end

  def update_password_changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_password(:password)
    |> put_pass_hash()
    |> change(%{reset_sent_at: nil})
  end

  defp unique_email(changeset) do
    changeset
    |> validate_format(
      :email,
      ~r/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-\.]+\.[a-zA-Z]{2,}$/
    )
    |> validate_length(:email, max: 255)
    |> unique_constraint(:email)
  end

  # In the function below, strong_password? just checks that the password
  # is at least 8 characters long.
  # See the documentation for NotQwerty123.PasswordStrength.strong_password?
  # for a more comprehensive password strength checker.
  defp validate_password(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, password ->
      case strong_password?(password) do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || msg}]
      end
    end)
  end

  # If you are using Argon2 or Pbkdf2, change Bcrypt to Argon2 or Pbkdf2
  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset

  defp strong_password?(password) when byte_size(password) > 7 do
    {:ok, password}
  end

  defp strong_password?(_), do: {:error, "The password is too short"}
end
