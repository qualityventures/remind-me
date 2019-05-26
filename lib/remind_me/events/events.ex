defmodule RemindMe.Events do
  import Ecto.Query, warn: false

  alias RemindMe.Repo
  alias RemindMe.Events.Event

  def next_event do
    from(e in Event, order_by: e.datetime, limit: 1)
    |> Repo.one()
  end

  def process_event(nil), do: nil

  def process_event(%Event{} = event) do
    now = DateTime.utc_now()

    if DateTime.compare(event.datetime, now) == :lt do
      event = Repo.preload(event, :user)

      subject = event.body |> String.split() |> Enum.take(7) |> Enum.join(" ")

      subject
      |> RemindMe.Email.email_from_message(event.body, event.user.email)
      |> RemindMe.Mailer.deliver_now()

      delete_event(event)
    end
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

  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end
end
