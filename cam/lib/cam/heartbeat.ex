defmodule Cam.Heartbeat do
  use GenServer

  def start_link(nil) do
    GenServer.start_link(__MODULE__, Cam.node_name(), name: __MODULE__)
  end

  @impl GenServer
  def init(name) do
    schedule_heartbeat()
    {:ok, name}
  end

  @impl GenServer
  def handle_info(:heartbeat, name) do
    require Logger

    case send_heartbeat(name) do
      {:ok, _response} ->
        :ok

      {:error, something} ->
        Logger.error("Heartbeat Error: #{inspect(something)}")
    end

    schedule_heartbeat()
    {:noreply, name}
  end

  defp send_heartbeat(name) do
    request = {
      'http://screen.riesd.com/api/checkin',
      [],
      'application/json',
      Jason.encode!(%{name: name})
    }

    :httpc.request(:post, request, [timeout: 15_000], sync: true)
  end

  @refresh_period 3_000
  defp schedule_heartbeat do
    Process.send_after(self(), :heartbeat, @refresh_period)
  end
end
