defmodule ScreenWeb.DashboardLive do
  use ScreenWeb, :live_view
  alias Screen.Cameras

  @refresh_timeout 1_000

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    if connected?(socket) do
      schedule_refresh()
    end

    {:ok, load_cameras(socket)}
  end

  @impl Phoenix.LiveView
  def handle_info(:tick, socket) do
    schedule_refresh()
    {:noreply, load_cameras(socket)}
  end

  defp load_cameras(socket) do
    cameras =
      Cameras.list_cameras()
      |> Enum.map(&%{name: &1.name, ago: Screen.RelativeTime.time_ago(&1.last_seen)})

    socket |> assign(cameras: cameras)
  end

  defp schedule_refresh do
    Process.send_after(self(), :tick, @refresh_timeout)
  end
end
