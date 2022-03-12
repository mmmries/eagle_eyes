defmodule Screen.Cameras.Camera do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "cameras" do
    field :last_seen, :utc_datetime
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(camera, attrs) do
    camera
    |> cast(attrs, [:name, :last_seen])
    |> validate_required([:name, :last_seen])
  end
end
