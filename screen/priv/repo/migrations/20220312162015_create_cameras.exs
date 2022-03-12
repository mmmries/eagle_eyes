defmodule Screen.Repo.Migrations.CreateCameras do
  use Ecto.Migration

  def change do
    create table(:cameras, primary_key: false) do
      add :name, :string, primary_key: true
      add :last_seen, :utc_datetime

      timestamps()
    end
  end
end
