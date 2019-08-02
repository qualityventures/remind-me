defmodule RemindMeWeb.MessageReceiveController do
  use RemindMeWeb, :controller

  require Logger

  alias RemindMe.{Repo, Connections, Emails}
  alias RemindMe.Messages.Message
  alias RemindMe.Emails.Mailer

  # Process if it's just a single message
  def process(conn, params) do
    body = params["body"]
    from = params["from"]
    sms_id = params["sms_id"]
    to = params["to"]

    connections = Connections.find_connections_by_phone(from)

    connection =
      Enum.find(connections, fn c -> c.server_number.number == Connections.format_phone(to) end)

    case connection do
      nil ->
        # Return 200 with no body
        text(conn, "")

      _ ->
        user = connection.user
        # Create a subject line from the first 7 words in the body.
        subject =
          body
          |> String.split()
          |> Enum.take(7)
          |> Enum.join(" ")

        # Save the received message into the database.
        Repo.insert(%Message{
          body: body,
          from: from,
          message_sid: sms_id,
          to: to,
          user_id: user.id
        })

        # Send the email.
        subject
        |> Emails.email_from_message(body, connection.destination.email)
        |> Mailer.deliver_now()

        # Return 200 with no body
        text(conn, "")
    end
  end
end
