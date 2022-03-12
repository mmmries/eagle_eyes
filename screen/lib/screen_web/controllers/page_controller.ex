defmodule ScreenWeb.PageController do
  use ScreenWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end


end
