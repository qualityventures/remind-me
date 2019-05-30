defmodule RemindMeWeb.InboundParseController do
  use RemindMeWeb, :controller

  import Bamboo.Email

  alias RemindMe.Emails.Mailer

  def new(conn, %{"html" => html, "subject" => subject, "from" => from}) do
    new_email()
    |> to({"Damon Janis", "damonvjanis@gmail.com"})
    |> from({"Remind Me Support", "support@remindme.live"})
    |> put_header("reply-to", from)
    |> subject(subject)
    |> html_body(html)
    |> Mailer.deliver_now()

    send_resp(conn, 200, "")
  end
end
