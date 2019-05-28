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
    |> validate_future_date()
  end

  def validate_future_date(%{changes: changes} = changeset) when changes == %{}, do: changeset

  def validate_future_date(changeset) do
    value = Map.get(changeset.changes, :datetime)

    case DateTime.compare(value, DateTime.utc_now()) do
      :gt -> changeset
      _ -> add_error(changeset, :datetime, "date must be in the future")
    end
  end
end
