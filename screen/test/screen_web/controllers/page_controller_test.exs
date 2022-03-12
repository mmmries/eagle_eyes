defmodule ScreenWeb.PageControllerTest do
  use ScreenWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Cameras"
  end

  test "POST /checkin", %{conn: conn} do
    conn = post(conn, "/checkin", %{"name" => "foo"})
    assert json_response(conn, 200) == %{"ok" => true}
  end
end
