defmodule RemindMeWeb.MessageReceiveController do
  use RemindMeWeb, :controller

  alias RemindMe.{Repo, Message, Connections, Messages}

  # Process if it's a multi-part message
  def process(conn, %{"concat" => "true"} = params) do
    body = params["text"]
    from = params["msisdn"]
    message_sid = params["messageId"]
    to = params["to"]
    ref = params["concat-ref"]
    total = params["concat-total"]
    part = params["concat-part"]

    IO.inspect params

    # Save partial message in database
    Messages.create_message_concat(%{
      body: body,
      part: part,
      ref: ref,
      total: total,
      to: to
    })

    messages = Messages.get_concat_by_ref(ref, to)

    if length(messages) == String.to_integer(total) do
      full_body =
        messages
        |> Enum.sort_by(fn m -> m.part end)
        |> Enum.map(fn m -> m.body end)
        |> Enum.join(" ")

      for message <- messages do
        Messages.delete_message_concat(message)
      end

      connections = Connections.find_connections_by_phone(from)

      connection =
        Enum.find(connections, fn c -> c.server_number.number == Connections.format_phone(to) end)

      if !is_nil(connection) do
        user = connection.user
        # Create a subject line from the first 7 words in the body.
        subject =
          full_body
          |> String.split()
          |> Enum.take(7)
          |> Enum.join(" ")

        # Save the received message into the database.
        Repo.insert(%Message{
          body: full_body,
          from: from,
          message_sid: message_sid,
          to: to,
          user_id: user.id
        })

        # Send the email.
        subject
        |> RemindMeWeb.Email.email_from_message(full_body, connection.destination.email)
        |> RemindMe.Mailer.deliver_now()
      end
    end
    # Return 200 with no body
    text(conn, "")
  end

  # Process if it's just a single message
  def process(conn, params) do
    body = params["text"]
    from = params["msisdn"]
    message_sid = params["messageId"]
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
