defmodule RemindMe.Repo.Migrations.RemoveSessionsFromUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :sessions
    end
  end
end
