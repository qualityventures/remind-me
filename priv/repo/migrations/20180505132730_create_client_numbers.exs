defmodule RemindMe.Repo.Migrations.CreateClientNumbers do
  use Ecto.Migration

  def change do
    create table(:client_numbers) do
      add(:number, :string)
      add(:connection_id, references(:connections, on_delete: :delete_all))

      timestamps()
    end

    create(index(:client_numbers, [:connection_id]))
  end
end
