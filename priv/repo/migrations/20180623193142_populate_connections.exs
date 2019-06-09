defmodule RemindMe.Repo.Migrations.PopulateConnections do
  use Ecto.Migration

  # alias RemindMe.Accounts
  # alias RemindMe.Connections

  def up do
    # users = Accounts.list_users()

    # for user <- users do
    #   {:ok, server_number} = Connections.find_next_server_number(user)

    #   Connections.create_connection(%{
    #     "user_id" => user.id,
    #     "server_number_id" => server_number.id,
    #     "client_number" => %{"number" => user.phone},
    #     "destination" => %{"email" => user.email, "type" => "email"}
    #   })
    # end
  end

  def down do
    # connections = Connections.list_connections()

    # for connection <- connections do
    #   Connections.delete_connection(connection)
    # end
  end
end
