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
    assert json_response(conn, 200) == %{"ok" => true}
  end

  defp sample_clip_path do
    Path.join([__DIR__, "../../support/fixtures/small-sample.mp4"])
  end
end
