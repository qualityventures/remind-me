defmodule RemindMe.Events.Event do
  use Ecto.Schema

  import Ecto.Changeset

  alias RemindMe.Accounts
  alias RemindMe.Accounts.User

  schema "events" do
    field :body, :string
    field :datetime, :utc_datetime
    field :recurring, :string

    timestamps()

    belongs_to :user, User
  end

  def changeset(event, attrs) do
    event
    |> cast(attrs, [:datetime, :body, :recurring, :user_id])
    |> validate_required([:datetime, :body, :user_id])
    |> validate_future_date()
  end

  def validate_future_date(%{changes: %{datetime: datetime}} = changeset) do
    IO.inspect(datetime)
    user = Accounts.get(get_field(changeset, :user_id))
    {:ok, now} = DateTime.now(user.timezone)
    naive_now = DateTime.to_naive(now)

    case NaiveDateTime.compare(DateTime.to_naive(datetime), naive_now) do
      :gt -> changeset
      _ -> add_error(changeset, :datetime, "date must be in future, check timezone in settings")
    end
  end

  def validate_future_date(changeset), do: changeset
end
