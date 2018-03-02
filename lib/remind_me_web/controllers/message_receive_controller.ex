defmodule RemindMeWeb.MessageReceiveController do
  use RemindMeWeb, :controller
  alias RemindMe.{Repo, Message}

  def process(conn, params) do
    body = params["text"]

    # Create a subject line from the first 7 words in the body.
    subject =
      body
      |> String.split()
      |> Enum.take(7)
      |> Enum.join(" ")

    # Save the received message into the database.
    Repo.insert(%Message{
      body: body,
      from: params["msisdn"],
      message_sid: params["messageId"],
      to: params["to"]
    })

    # Send the email.
    subject
    |> RemindMeWeb.Email.email_from_message(body)
    |> RemindMe.Mailer.deliver_now()
    
    # Return 200 with no body               
    text conn, ""
  end
end