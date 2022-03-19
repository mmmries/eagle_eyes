defmodule ScreenWeb.DashboardLive do
  use ScreenWeb, :live_view
  alias Screen.Cameras

  @refresh_timeout 1_000

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    if connected?(socket) do
      schedule_refresh()
    end

    socket =
      socket
      |> load_cameras()
      |> load_clips()
      |> assign(watching: nil)

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("watch", %{"id" => id}, socket) do
    clip = Cameras.get_clip!(String.to_integer(id))
    {:noreply, assign(socket, watching: clip)}
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

  defp load_clips(socket) do
    assign(socket, clips: Screen.Cameras.recent_clips(10))
  end

  defp schedule_refresh do
    Process.send_after(self(), :tick, @refresh_timeout)
  end

  defp ts(timestamp) do
    DateTime.from_unix!(timestamp) |> DateTime.to_iso8601()
  end
end
