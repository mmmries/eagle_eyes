defmodule Screen.DiskWatcher do
  use GenServer
  alias Screen.Cameras
  require Logger
  @check_interval 30_000

  def start_link(nil) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl GenServer
  def init(nil) do
    {:ok, nil, @check_interval}
  end

  @impl GenServer
  def handle_info(:timeout, nil) do
    check_disk_usage()
    {:noreply, nil, @check_interval}
  end

  def check_disk_usage do
    if Cameras.total_clip_size() > max_disk_usage() do
      Logger.info("Disk usage over limit, pruning 100 old clips")
      Cameras.cleanup_old_clips(100)
    end
  end

  def max_disk_usage do
    :screen
    |> Application.get_env(:clips, %{})
    |> Map.fetch!(:max_disk_usage)
  end
end
