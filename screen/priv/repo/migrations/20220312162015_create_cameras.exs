defmodule Screen.Repo.Migrations.CreateCameras do
  use Ecto.Migration

  def change do
    create table(:cameras, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :last_seen, :utc_datetime

      timestamps()
    end
  end
end
