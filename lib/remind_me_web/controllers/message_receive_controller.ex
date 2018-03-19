defmodule RemindMeWeb.MessageReceiveController do
  use RemindMeWeb, :controller
  alias RemindMe.{Repo, Message}

  def process(conn, %{"text" => body, "msisdn" => from, "messageId" => message_sid, "to" => to}) do
    user = RemindMe.Accounts.get_by_phone(from)

    case user do
      nil ->
        # Return 200 with no body
        text conn, ""
      user ->
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
          to: to
        })

        # Send the email.
        subject
          |> RemindMeWeb.Email.email_from_message(body, user.email)
          |> RemindMe.Mailer.deliver_now()

        # Return 200 with no body
        text conn, ""
    end
  end
end
