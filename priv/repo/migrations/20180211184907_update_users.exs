defmodule RemindMe.Repo.Migrations.UpdateUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :email, :string
      add :password_hash, :string
      add :confirmed_at, :utc_datetime
      add :reset_sent_at, :utc_datetime
      add :sessions, {:map, :integer}, default: "{}"
      
      remove :username
      remove :password
      remove :app_name
    end

    create unique_index :users, [:email]
  end
end
