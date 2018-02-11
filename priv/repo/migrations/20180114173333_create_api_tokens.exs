defmodule RemindMe.Repo.Migrations.CreateApiTokens do
  use Ecto.Migration

  def change do
    create table("api_tokens") do
      add :app_name, :string
      add :access_token, :string
      add :refresh_token, :string

      timestamps()
    end
  end
end
