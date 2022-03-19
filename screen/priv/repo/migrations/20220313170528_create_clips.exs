defmodule Screen.Repo.Migrations.CreateClips do
  use Ecto.Migration

  def change do
    create table(:clips) do
      add :timestamp, :integer
      add :bytesize, :integer
      add :camera_name, references(:cameras, column: :name, on_delete: :nothing, type: :string)

      timestamps(type: :utc_datetime_usec)
    end

    create index(:clips, [:camera_name])
  end
end
