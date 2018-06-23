defmodule RemindMe.Repo.Migrations.CreateDestinations do
  use Ecto.Migration

  def change do
    create table(:destinations) do
      add(:type, :string, default: "email")
      add(:email, :string)
      add(:connection_id, references(:connections, on_delete: :delete_all))

      timestamps()
    end

    create(index(:destinations, [:connection_id]))
  end
end
