defmodule ScreenWeb.PageController do
  use ScreenWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def checkin(conn, %{"name" => name}) do
    Screen.Cameras.checkin(name)
    json(conn, %{"ok" => true})
  end

  def create_clip(conn, %{"file" => %Plug.Upload{path: path, filename: filename}, "name" => name}) do
    [timestamp, "mp4"] = String.split(filename, ".")
    %File.Stat{size: bytesize} = File.stat!(path)
    camera = Screen.Cameras.get_camera!(name)

    {:ok, clip} =
      Screen.Cameras.create_clip(camera, %{
        timestamp: timestamp,
        bytesize: bytesize
      })

    Screen.Cameras.save_clip_file(clip, path)

    json(conn, %{"ok" => true, "id" => clip.id})
  end
end
