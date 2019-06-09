defmodule RemindMe.Messages.MessageConcat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages_concat" do
    field :body, :string
    field :part, :integer
    field :ref, :string
    field :to, :string
    field :total, :integer

    timestamps()
  end

  @doc false
  def changeset(message_concat, attrs) do
    message_concat
    |> cast(attrs, [:ref, :total, :part, :body, :to])
    |> validate_required([:ref, :total, :part, :body, :to])
  end
end
