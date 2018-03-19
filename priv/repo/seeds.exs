# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# It is also run when you use the command `mix ecto.setup`
#

users = [
  # %{email: "jane.doe@remindme.live", password: "password"},
  # %{email: "john.smith@example.org", password: "password"}
]

for user <- users do
  {:ok, user} = RemindMe.Accounts.create_user(user)
  RemindMe.Accounts.confirm_user(user)
end
