defmodule RemindMe.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :datetime, :utc_datetime
      add :body, :text
      add :recurring, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:events, [:user_id])
    create index(:events, [:datetime])
  end
end
