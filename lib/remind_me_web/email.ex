defmodule RemindMeWeb.Email do
  import Bamboo.Email

  def email_from_message(message_subject, message_body, email) do
    new_email()
    |> to(email)
    |> from({"To Do", "todo@remindme.live"})
    |> subject(message_subject)
    |> html_body(message_body)
    |> text_body(message_body)
  end
end
