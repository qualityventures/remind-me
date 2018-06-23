defmodule RemindMe.Connections.Connection do
  use Ecto.Schema

  import Ecto.Changeset

  alias RemindMe.Connections

  schema "connections" do
    belongs_to(:user, RemindMe.Accounts.User)
    belongs_to(:server_number, RemindMe.Connections.ServerNumber)
    has_one(:destination, RemindMe.Connections.Destination)
    has_one(:client_number, RemindMe.Connections.ClientNumber)

    timestamps()
  end

  def changeset(connection, attrs) do
    case check_unique_number(attrs) do
      {:error, message} ->
        connection
        |> cast(attrs, [:user_id, :server_number_id])
        |> cast_assoc(:destination, required: true)
        |> cast_assoc(:client_number, required: true)
        |> validate_required([:user_id, :server_number_id])
        |> format_phone()
        |> add_error(:client_number, message)

      {:ok, attrs} ->
        connection
        |> cast(attrs, [:user_id, :server_number_id])
        |> cast_assoc(:destination, required: true)
        |> cast_assoc(:client_number, required: true)
        |> validate_required([:user_id, :server_number_id])
        |> format_phone()
    end
  end

  # Checks to see if client number is already connected to server number,
  # tries to swap it for a different server number if it is, and gives an
  # error message to the user if there aren't any server numbers left.
  defp check_unique_number(%{"server_number_id" => _} = attrs) do
    Connections.check_unique_server_number(attrs)
  end

  defp check_unique_number(attrs) do
    {:ok, attrs}
  end

  defp format_phone(%{changes: %{client_number: _}} = changeset) do
    client_number = changeset.changes.client_number

    new_phone = Connections.format_phone(client_number.changes.number)

    client_number = change(client_number, %{number: new_phone})
    change(changeset, client_number: client_number)
  end

  defp format_phone(changeset) do
    changeset
  end
end
