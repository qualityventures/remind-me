defmodule RemindMe.Repo.Migrations.ModifyBodyToTextFromString do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      modify(:body, :text, from: :string)
    end
  end
end
