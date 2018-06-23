defmodule RemindMe.Connections.Destination do
  use Ecto.Schema
  import Ecto.Changeset


  schema "destinations" do
    field :email, :string
    field :type, :string
    field :connection_id, :id

    timestamps()
  end

  @doc false
  def changeset(destination, attrs) do
    destination
    |> cast(attrs, [:type, :email])
    |> validate_required([:type])
    |> validate_inclusion(:type, ["email"])
    |> validate_format(:email, ~r{@})
  end
end
