defmodule RemindMe.Connections.ServerNumber do
  use Ecto.Schema
  import Ecto.Changeset

  schema "server_numbers" do
    field(:number, :string)

    timestamps()

    has_many(:connections, RemindMe.Connections.Connection)
  end

  @doc false
  def changeset(server_number, attrs) do
    server_number
    |> cast(attrs, [:number])
    |> validate_required([:number])
  end
end
