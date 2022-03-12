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
        last_seen: ~U[2022-03-11 16:20:00Z],
        name: "some name"
      })
      |> Screen.Cameras.create_camera()

    camera
  end
end
