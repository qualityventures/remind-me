defmodule RemindMeWeb.MessageReceiveController do
  use RemindMeWeb, :controller

  alias RemindMe.{Repo, Message, Connections}

  def process(conn, %{"text" => body, "msisdn" => from, "messageId" => message_sid, "to" => to}) do
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
          message_sid: message_sid,
          to: to,
          user_id: user.id
        })

        # Send the email.
        subject
        |> RemindMeWeb.Email.email_from_message(body, connection.destination.email)
        |> RemindMe.Mailer.deliver_now()

        # Return 200 with no body
        text(conn, "")
    end
  end
end
