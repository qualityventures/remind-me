defmodule RemindMe.Repo.Migrations.RemoveTwilioFields do
  use Ecto.Migration

  def change do
    alter table :messages do
      remove(:from_city)
      remove(:from_state)
      remove(:from_zip)
      remove(:from_country)
      remove(:num_segments)
      remove(:sms_message_sid)
      remove(:sms_sid)
      remove(:sms_status)
    end
  end
end
