defmodule RemindMe.Repo.Migrations.CreateMessagesConcat do
  use Ecto.Migration

  def change do
    create table(:messages_concat) do
      add :ref, :string
      add :total, :integer
      add :part, :integer
      add :body, :text
      add :to, :string

      timestamps()
    end

  end
end
