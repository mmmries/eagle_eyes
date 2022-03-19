defmodule Screen.CamerasFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Screen.Cameras` context.
  """

  @doc """
  Generate a camera.
  """
  def camera_fixture(attrs \\ %{}) do
    {:ok, camera} =
      attrs
      |> Enum.into(%{
        last_seen: ~U[2020-03-11 16:20:00Z],
        name: "some name"
      })
      |> Screen.Cameras.create_camera()

    camera
  end

  @doc """
  Generate a clip.
  """
  def clip_fixture(camera, attrs \\ %{}) do
    attributes =
      attrs
      |> Enum.into(%{
        timestamp: 1_646_827_320,
        bytesize: 100
      })

    {:ok, clip} = Screen.Cameras.create_clip(camera, attributes)

    clip
  end
end
