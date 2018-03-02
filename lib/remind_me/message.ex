defmodule RemindMe.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias RemindMe.Message


  schema "messages" do
    field :body, :string
    field :from, :string
    field :from_city, :string
    field :from_country, :string
    field :from_state, :string
    field :from_zip, :string
    field :message_sid, :string
    field :num_segments, :integer
    field :sms_message_sid, :string
    field :sms_sid, :string
    field :sms_status, :string
    field :to, :string

    timestamps()
  end

  @doc false
  def changeset(%Message{} = message, attrs) do
    message
    |> cast(attrs, [:body, :from, :from_city, :from_country, :from_state, :from_zip, :message_sid, :num_segments, :sms_message_id, :sms_sid, :sms_status, :to])
    |> validate_required([:body, :from, :from_city, :from_country, :from_state, :from_zip, :message_sid, :num_segments, :sms_message_id, :sms_sid, :sms_status, :to])
  end
end
