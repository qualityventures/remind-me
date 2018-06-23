defmodule RemindMe.Repo.Migrations.PopulateServerNumbers do
  use Ecto.Migration

  alias RemindMe.Connections

  def up do
    Connections.create_server_number(%{number: "201-331-3515"})
    Connections.create_server_number(%{number: "667-308-3511"})
  end

  def down do
    numbers = Connections.list_server_numbers()

    for number <- numbers do
      Connections.delete_server_number(number)
    end
  end
end
