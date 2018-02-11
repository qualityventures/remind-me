defmodule RemindMe.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :string
      add :from, :string
      add :from_city, :string
      add :from_country, :string
      add :from_state, :string
      add :from_zip, :string
      add :message_sid, :string
      add :num_segments, :integer
      add :sms_message_id, :string
      add :sms_sid, :string
      add :sms_status, :string
      add :to, :string

      timestamps()
    end

  end
end
