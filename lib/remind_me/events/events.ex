defmodule RemindMe.Events do
  import Ecto.Query, warn: false

  alias RemindMe.Messages
  alias RemindMe.Repo
  alias RemindMe.Emails
  alias RemindMe.Emails.Mailer
  alias RemindMe.Events.Event

  @day 24 * 60 * 60
  @week 7 * @day
  @frequencies ["Daily", "Weekly", "Monthly", "Quarterly", "Yearly"]

  def frequencies, do: @frequencies

  def next_event do
    from(e in Event, order_by: e.datetime, limit: 1)
    |> Repo.one()
  end

  def process_event(nil), do: nil

  def process_event(%Event{} = event) do
    now = DateTime.utc_now()

    with true <- DateTime.compare(event.datetime, now) == :lt,
         event = Repo.preload(event, :user),
         subject = build_subject(event.body) do
      # Send email, log message, and create next event without regard to success
      # in case something fails so the process doesn't block up
      Agent.start(fn -> send_email(subject, event.body, event.user.email) end)
      Agent.start(fn -> Messages.create_message(%{body: event.body, user_id: event.user_id}) end)
      Agent.start(fn -> create_next_event(event) end)

      delete_event(event)

      # Call function recursively to immediately process next event, in case
      # more than one event is due for processing
      process_event(next_event())
    end
  end

  def build_subject(body) do
    body
    |> String.split()
    |> Enum.take(7)
    |> Enum.join(" ")
  end

  def send_email(subject, body, email) do
    subject
    |> Emails.email_from_message(body, email)
    |> Mailer.deliver_now()
  end

  def create_next_event(%{recurring: nil}), do: nil

  def create_next_event(%{recurring: "Daily"} = event) do
    next = DateTime.add(event.datetime, 1 * @day)

    %{Map.from_struct(event) | datetime: next}
    |> create_event()
  end

  def create_next_event(%{recurring: "Weekly"} = event) do
    next = DateTime.add(event.datetime, 1 * @week)

    %{Map.from_struct(event) | datetime: next}
    |> create_event()
  end

  def create_next_event(%{recurring: "Monthly"} = event) do
    next = add_months(event.datetime, 1)

    %{Map.from_struct(event) | datetime: next}
    |> create_event()
  end

  def create_next_event(%{recurring: "Quarterly"} = event) do
    next = add_months(event.datetime, 3)

    %{Map.from_struct(event) | datetime: next}
    |> create_event()
  end

  def create_next_event(%{recurring: "Yearly"} = event) do
    next = add_months(event.datetime, 12)

    %{Map.from_struct(event) | datetime: next}
    |> create_event()
  end

  def add_months(%DateTime{} = datetime, num) do
    date = DateTime.to_date(datetime)
    time = DateTime.to_time(datetime)

    new_year = date.year + div(date.month + num - 1, 12)
    new_month = get_month(date.month + num)
    new_day = get_day(date.day, Date.new(new_year, new_month, 1))
    {:ok, new_date} = Date.new(new_year, new_month, new_day)

    {:ok, naive} = NaiveDateTime.new(new_date, time)
    DateTime.from_naive!(naive, "Etc/UTC")
  end

  def get_month(total_months) when rem(total_months, 12) == 0, do: 12
  def get_month(total_months), do: rem(total_months, 12)

  def get_day(day, {:ok, _first_of_month}) when day <= 28, do: day
  def get_day(day, {:ok, first_of_month}), do: min(day, Date.days_in_month(first_of_month))

  def list_events_by_user(user) do
    from(e in Event, where: e.user_id == ^user.id, select: e)
    |> Repo.all()
  end

  def list_events do
    Repo.all(Event)
  end

  def get_event!(id), do: Repo.get!(Event, id)

  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  def change_event(%Event{} = event), do: Event.changeset(event, %{})

  def dt_params_to_utc(datetime, timezone) do
    %{"year" => y, "month" => m, "day" => d, "hour" => h, "minute" => min} = datetime
    [y, m, d, h, min] = Enum.map([y, m, d, h, min], &String.to_integer/1)
    {:ok, naive} = NaiveDateTime.new(y, m, d, h, min, 0)
    datetime_to_utc(naive, timezone)
  end

  def datetime_to_utc(naive, timezone) do
    with_tz = DateTime.from_naive!(naive, timezone)
    {:ok, utc_time} = DateTime.shift_zone(with_tz, "Etc/UTC")
    utc_time
  end

  def datetime_from_utc(datetime, timezone) do
    {:ok, with_tz} = DateTime.shift_zone(datetime, timezone)
    with_tz
  end
end
