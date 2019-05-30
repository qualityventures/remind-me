defmodule RemindMe.Events.Event do
  use Ecto.Schema

  import Ecto.Changeset

  alias RemindMe.Events
  alias RemindMe.Accounts.User

  schema "events" do
    field :body, :string
    field :datetime, :utc_datetime
    field :recurring, :string

    timestamps()

    belongs_to :user, User
  end

  def reset_dt_to_user_tz(changeset, timezone) do
    datetime = get_field(changeset, :datetime)
    change(changeset, %{datetime: Events.datetime_from_utc(datetime, timezone)})
  end

  def changeset(event, attrs) do
    event
    |> cast(attrs, [:datetime, :body, :recurring, :user_id])
    |> validate_required([:datetime, :body, :user_id])
    |> validate_future_date()
  end

  def validate_future_date(%{changes: %{datetime: datetime}} = changeset) do
    case DateTime.compare(datetime, DateTime.utc_now()) do
      :gt -> changeset
      _ -> add_error(changeset, :datetime, "date must be in future, check timezone in settings")
    end
  end

  def validate_future_date(changeset), do: changeset
end
