defmodule ScreenWeb.DashboardLive do
  use ScreenWeb, :live_view
  alias Screen.Cameras

  @refresh_timeout 1_000

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(cameras: Cameras.list_cameras())

    if connected?(socket) do
      schedule_refresh()
    end

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_info(:tick, socket) do
    socket = assign(socket, cameras: Cameras.list_cameras())

    schedule_refresh()
    {:noreply, socket}
  end

  defp schedule_refresh do
    Process.send_after(self(), :tick, @refresh_timeout)
  end
end
