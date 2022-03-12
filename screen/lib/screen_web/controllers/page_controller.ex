defmodule ScreenWeb.PageController do
  use ScreenWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def checkin(conn, %{"name" => name}) do
    Screen.Cameras.checkin(name)
    json(conn, %{"ok" => true})
  end
end
