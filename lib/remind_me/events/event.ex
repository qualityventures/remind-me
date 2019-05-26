defmodule RemindMe.Events.Event do
  use Ecto.Schema

  import Ecto.Changeset

  alias RemindMe.Accounts.User

  schema "events" do
    field :body, :string
    field :datetime, :utc_datetime
    field :recurring, :string

    timestamps()

    belongs_to :user, User
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:datetime, :body, :recurring, :user_id])
    |> validate_required([:datetime, :body, :user_id])
  end
end
