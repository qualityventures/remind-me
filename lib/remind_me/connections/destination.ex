defmodule RemindMe.Connections.Destination do
  use Ecto.Schema
  import Ecto.Changeset

  alias RemindMe.Connections.Connection

  schema "destinations" do
    field :email, :string
    field :type, :string

    timestamps()

    belongs_to :connection, Connection
  end

  @doc false
  def changeset(destination, attrs) do
    destination
    |> cast(attrs, [:type, :email, :connection_id])
    |> validate_required([:type])
    |> validate_inclusion(:type, ["email"])
    |> validate_format(:email, ~r{@})
  end
end
