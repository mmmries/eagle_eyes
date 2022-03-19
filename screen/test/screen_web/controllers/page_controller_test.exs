defmodule ScreenWeb.PageControllerTest do
  use ScreenWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Cameras"
  end

  test "POST /api/checkin", %{conn: conn} do
    conn = post(conn, "/api/checkin", %{"name" => "foo"})
    assert json_response(conn, 200) == %{"ok" => true}
  end

  test "POST /api/clips", %{conn: conn} do
    {:ok, _cam} =
      Screen.Cameras.create_camera(%{
        name: "cam1",
        last_seen: DateTime.utc_now()
      })

    params = %{
      "name" => "cam1",
      "file" => %Plug.Upload{
        filename: "1647679809.mp4",
        path: sample_clip_path()
      }
    }

    conn = post(conn, "/api/clips", params)
    assert %{"ok" => true, "id" => id} = json_response(conn, 200)

    clip = Screen.Cameras.get_clip!(id)
    assert clip.camera_name == "cam1"
    assert clip.bytesize == 543_879
    assert clip.timestamp == 1_647_679_809
  end

  defp sample_clip_path do
    Path.join([__DIR__, "../../support/fixtures/small-sample.mp4"])
  end
end
