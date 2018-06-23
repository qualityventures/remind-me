defmodule RemindMe.Repo.Migrations.CreateConnections do
  use Ecto.Migration

  def change do
    create table(:connections) do
      add(:user_id, references(:users, on_delete: :delete_all))
      add(:server_number_id, references(:server_numbers, on_delete: :nothing))

      timestamps()
    end

    create(index(:connections, [:user_id]))
    create(index(:connections, [:server_number_id]))
  end
end
