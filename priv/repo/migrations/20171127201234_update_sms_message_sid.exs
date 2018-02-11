defmodule RemindMe.Repo.Migrations.UpdateSmsMessageSid do
  use Ecto.Migration

  def change do
    rename table("messages"), :sms_message_id, to: :sms_message_sid
  end
end
