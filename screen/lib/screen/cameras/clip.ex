defmodule Screen.Cameras.Clip do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "clips" do
    field :timestamp, :integer

    timestamps(type: :utc_datetime_usec)

    belongs_to :camera, Screen.Cameras.Camera, type: :string, foreign_key: :camera_name, source: :camera_name
  end

  @doc false
  def changeset(clip, attrs) do
    clip
    |> cast(attrs, [:timestamp])
    |> validate_required([:timestamp])
  end
end
