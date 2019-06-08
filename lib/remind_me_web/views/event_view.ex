defmodule RemindMeWeb.EventView do
  use RemindMeWeb, :view

  alias RemindMe.Events

  @abr_months ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
  @months Enum.with_index(@abr_months, 1) |> Enum.map(fn {m, i} -> {i, m} end) |> Map.new()

  def adjust_to_user_tz(datetime, timezone) do
    {:ok, with_tz} = DateTime.shift_zone(datetime, timezone)
    with_tz
  end

  def format_date(%{year: y, month: m, day: d, hour: h, minute: min}) do
    "#{month(m)} #{d}, #{y} at #{hour(h)}:#{zero_format(min)}#{am_or_pm(h)}"
  end

  defp month(month), do: @months[month]

  defp hour(hour) when hour == 0, do: 12
  defp hour(hour) when hour <= 12, do: hour
  defp hour(hour), do: hour - 12

  defp am_or_pm(hour) when hour < 12, do: "am"
  defp am_or_pm(_hour), do: "pm"

  defp zero_format(unit) when unit <= 9, do: "0#{unit}"
  defp zero_format(unit), do: unit

  def get_frequency_options() do
    options = Enum.map(Events.frequencies(), &{&1, &1})

    [{"Just this Once", nil} | options]
  end

  def today(timezone) do
    {:ok, datetime} = DateTime.now(timezone)
    datetime
  end
end
