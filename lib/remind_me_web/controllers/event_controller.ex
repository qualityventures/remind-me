defmodule RemindMeWeb.EventController do
  use RemindMeWeb, :controller

  import RemindMeWeb.Authorize

  alias RemindMe.Events
  alias RemindMe.Events.Event

  plug(:user_check)

  def index(conn, _params) do
    user = conn.assigns.current_user
    events = Events.list_events_by_user(user)
    render(conn, "index.html", events: events)
  end

  def new(conn, _params) do
    changeset = Event.changeset(%Event{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event" => %{"datetime" => datetime} = event_params}) do
    user = conn.assigns.current_user

    # Ensure current user id is used, and convert the datetime from the UI,
    # which is in the user's timezone, to UTC for storage
    event_params =
      event_params
      |> Map.put("user_id", user.id)
      |> Map.put("datetime", Events.dt_params_to_utc(datetime, user.timezone))

    case Events.create_event(event_params) do
      {:ok, _event} ->
        conn
        |> put_flash(:info, "Reminder created successfully.")
        |> redirect(to: Routes.event_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        changeset = Event.reset_dt_to_user_tz(changeset, user.timezone)
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    event = Events.get_event!(id)

    IO.inspect(event.datetime)

    # Convert to user's timezone before sending to UI
    event = %{event | datetime: Events.datetime_from_utc(event.datetime, user.timezone)}

    if event.user_id == user.id do
      changeset = Events.change_event(event)
      render(conn, "edit.html", event: event, changeset: changeset)
    else
      redirect(conn, to: Routes.event_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "event" => %{"datetime" => dt} = event_params}) do
    user = conn.assigns.current_user
    event = Events.get_event!(id)

    # Convert the datetime from the UI, which is in the user's timezone, to UTC for storage
    event_params = %{event_params | "datetime" => Events.dt_params_to_utc(dt, user.timezone)}

    if event.user_id == user.id do
      case Events.update_event(event, event_params) do
        {:ok, _event} ->
          conn
          |> put_flash(:info, "Reminder updated successfully.")
          |> redirect(to: Routes.event_path(conn, :index))

        {:error, %Ecto.Changeset{} = changeset} ->
          changeset = Event.reset_dt_to_user_tz(changeset, user.timezone)
          render(conn, "edit.html", event: event, changeset: changeset)
      end
    else
      redirect(conn, to: Routes.event_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Events.get_event!(id)

    if event.user_id == conn.assigns.current_user.id do
      {:ok, _event} = Events.delete_event(event)

      conn
      |> put_flash(:info, "Event deleted successfully.")
      |> redirect(to: Routes.event_path(conn, :index))
    else
      redirect(conn, to: Routes.event_path(conn, :index))
    end
  end
end
