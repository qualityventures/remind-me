defmodule RemindMe.Repo.Migrations.CreateServerNumbers do
  use Ecto.Migration

  def change do
    create table(:server_numbers) do
      add(:number, :string)

      timestamps()
    end
  end
end
