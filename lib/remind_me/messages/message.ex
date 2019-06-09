defmodule RemindMe.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias RemindMe.Messages.Message

  schema "messages" do
    field :body, :string
    field :from, :string
    field :message_sid, :string
    field :to, :string

    belongs_to(:user, RemindMe.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(%Message{} = message, attrs) do
    message
    |> cast(attrs, [:body, :from, :message_sid, :to, :user_id])
    |> validate_required([:body, :user_id])
  end
end
