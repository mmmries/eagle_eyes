defmodule Screen.Cameras do
  @moduledoc """
  The Cameras context.
  """

  import Ecto.Query, warn: false
  alias Screen.Repo

  alias Screen.Cameras.Camera

  @doc """
  Receive a hearbeat checkin from one of the cameras

  This will either create or update the associated camera record
  """
  def checkin(name) do
    now = DateTime.utc_now()

    camera = %Camera{
      name: name,
      last_seen: now,
      inserted_at: now,
      updated_at: now
    }

    Repo.insert!(camera,
      on_conflict: {:replace, [:last_seen, :updated_at]},
      conflict_target: :name
    )
  end

  @doc """
  Returns the list of cameras.

  ## Examples

      iex> list_cameras()
      [%Camera{}, ...]

  """
  def list_cameras do
    Repo.all(Camera)
  end

  @doc """
  Gets a single camera.

  Raises `Ecto.NoResultsError` if the Camera does not exist.

  ## Examples

      iex> get_camera!("cam1")
      %Camera{name: "cam1"}

      iex> get_camera!("foo")
      ** (Ecto.NoResultsError)

  """
  def get_camera!(name), do: Repo.get!(Camera, name)

  @doc """
  Creates a camera.

  ## Examples

      iex> create_camera(%{field: value})
      {:ok, %Camera{}}

      iex> create_camera(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_camera(attrs \\ %{}) do
    %Camera{}
    |> Camera.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a camera.

  ## Examples

      iex> update_camera(camera, %{field: new_value})
      {:ok, %Camera{}}

      iex> update_camera(camera, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_camera(%Camera{} = camera, attrs) do
    camera
    |> Camera.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a camera.

  ## Examples

      iex> delete_camera(camera)
      {:ok, %Camera{}}

      iex> delete_camera(camera)
      {:error, %Ecto.Changeset{}}

  """
  def delete_camera(%Camera{} = camera) do
    Repo.delete(camera)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking camera changes.

  ## Examples

      iex> change_camera(camera)
      %Ecto.Changeset{data: %Camera{}}

  """
  def change_camera(%Camera{} = camera, attrs \\ %{}) do
    Camera.changeset(camera, attrs)
  end

  alias Screen.Cameras.Clip

  def get_clip!(id), do: Repo.get!(Clip, id)

  def create_clip(camera, attrs \\ %{}) do
    camera
    |> Ecto.build_assoc(:clips)
    |> Clip.changeset(attrs)
    |> Repo.insert()
  end

  def save_clip_file(clip, filepath) do
    filename = "#{clip.id}.mp4"
    destination = Path.join([clips_dir(), filename])
    File.cp!(filepath, destination)
  end

  @doc """
  Deletes a clip.

  ## Examples

      iex> delete_clip(clip)
      {:ok, %Clip{}}

      iex> delete_clip(clip)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clip(%Clip{} = clip) do
    Repo.delete(clip)
  end

  defp clips_dir do
    :screen
    |> Application.get_env(:clips, %{})
    |> Map.fetch!(:dir)
  end
end
