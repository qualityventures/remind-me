defmodule RemindMe.Chron.EventsPoll do
  use GenServer

  alias RemindMe.Events

  def start_link() do
    case Mix.env() do
      :test -> :ignore
      _ -> GenServer.start_link(__MODULE__, %{})
    end
  end

  def init(state) do
    schedule_work()

    {:ok, state}
  end

  def handle_info(:work, state) do
    Events.process_event(Events.next_event())

    schedule_work()

    {:noreply, state}
  end

  defp schedule_work do
    # Every second
    Process.send_after(self(), :work, 1 * 1000)
  end
end
