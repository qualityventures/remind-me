defmodule RemindMe.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :first, :string
      add :last, :string
      add :phone, :string
    end
  end
end
