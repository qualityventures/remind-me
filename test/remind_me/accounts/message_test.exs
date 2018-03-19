defmodule RemindMe.Accounts.MessageTest do
  use ExUnit.Case
  use Bamboo.Test

  import RemindMeWeb.AuthCase
  alias RemindMe.Accounts.Message

  setup do
    email = "deirdre@remindme.live"
    {:ok, %{email: email, key: gen_key(email)}}
  end

  test "sends confirmation request email", %{email: email, key: key} do
    sent_email = Message.confirm_request(email, key)
    assert sent_email.subject =~ "Confirm your account"
    assert sent_email.text_body =~ "email here https://www.remindme.live/confirm?key="
    assert_delivered_email(Message.confirm_request(email, key))
  end

  test "sends no user found message for password reset attempt" do
    sent_email = Message.reset_request("gladys@remindme.live", nil)
    assert sent_email.text_body =~ "but no user is associated with the email you provided"
  end

  test "sends reset password request email", %{email: email, key: key} do
    sent_email = Message.reset_request(email, key)
    assert sent_email.subject =~ "Reset your password"
    assert sent_email.text_body =~ "password at https://www.remindme.live/password_resets/edit?key="
    assert_delivered_email(Message.reset_request(email, key))
  end

  test "sends receipt confirmation email", %{email: email} do
    sent_email = Message.confirm_success(email)
    assert sent_email.text_body =~ "account has been confirmed"
    assert_delivered_email(Message.confirm_success(email))
  end

  test "sends password reset email", %{email: email} do
    sent_email = Message.reset_success(email)
    assert sent_email.text_body =~ "password has been reset"
    assert_delivered_email(Message.reset_success(email))
  end
end
