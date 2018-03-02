defmodule RemindMeWeb.MessageReceiveController do
  use RemindMeWeb, :controller
  alias RemindMe.{Repo, Message}

  def process(conn, params) do
    body = params["Body"]

    # Create a subject line from the first 7 words in the body.
    subject = body
              |> String.split()
              |> Enum.take(7)
              |> Enum.join(" ")

    # Save the received message into the database.
    Repo.insert(%Message{
      body: params["Body"],
      from: params["From"],
      from_city: params["FromCity"],
      from_country: params["FromCountry"],
      from_state: params["FromState"],
      from_zip: params["FromZip"],
      message_sid: params["MessageSid"],
      num_segments: params["NumSegments"] |> String.to_integer,
      sms_message_sid: params["SmsMessageSid"],
      sms_sid: params["SmsSid"],
      sms_status: params["SmsStatus"],
      to: params["To"]
    })

    # Send the email.
    subject
    |> RemindMeWeb.Email.email_from_message(body)
    |> RemindMe.Mailer.deliver_now()
    
    # Return 200 with no body               
    text conn, ""
  end
end