defmodule RemindMe.Connections.ClientNumber do
  use Ecto.Schema
  import Ecto.Changeset


  schema "client_numbers" do
    field :number, :string

    belongs_to(:connection, RemindMe.Connections.Connection)

    timestamps()
  end

  @doc false
  def changeset(client_number, attrs) do
    client_number
    |> cast(attrs, [:number])
    |> validate_required([:number])
  end
end
