defmodule RemindMe.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias RemindMe.Message


  schema "messages" do
    field :body, :string
    field :from, :string
    field :message_sid, :string
    field :to, :string

    timestamps()
  end

  @doc false
  def changeset(%Message{} = message, attrs) do
    message
    |> cast(attrs, [:body, :from, :message_sid, :to])
    |> validate_required([:body, :from, :message_sid, :to])
  end
end
