defmodule Screen.Cameras.Camera do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:name, :string, []}
  @derive {Phoenix.Param, key: :name}
  schema "cameras" do
    field :last_seen, :utc_datetime_usec

    timestamps(type: :utc_datetime_usec)

    has_many :clips, Screen.Cameras.Clip, foreign_key: :camera_name
  end

  @doc false
  def changeset(camera, attrs) do
    camera
    |> cast(attrs, [:name, :last_seen])
    |> validate_required([:name, :last_seen])
    |> unique_constraint(:name)
  end
end
