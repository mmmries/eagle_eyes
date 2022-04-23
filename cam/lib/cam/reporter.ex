defmodule Cam.Reporter do
  use GenServer
  require Logger

  def start_link(nil) do
    GenServer.start_link(__MODULE__, Cam.node_name(), name: __MODULE__)
  end

  @impl GenServer
  def init(name) do
    immediate_check()
    {:ok, name}
  end

  @impl GenServer
  def handle_info(:check_for_files, name) do
    case get_file_list() do
      [] ->
        schedule_check()

      [first_file | _rest] ->
        send_file(first_file, name)
        immediate_check()
    end

    {:noreply, name}
  end

  @url "http://screen.riesd.com/api/clips"
  def send_file(filepath, name) do
    form = [{"name", name}, {:file, filepath}]
    case HTTPoison.post!(@url, {:multipart, form}, []) do
      %HTTPoison.Response{status_code: 200} ->
        # only delete it after it's been acknowledged
        File.rm!(filepath)
      other ->
        Logger.error("Failed to send clip: #{inspect(other)}")
    end
  end

  def get_file_list do
    pattern = Path.join(Cam.converted_clip_directory(), "*.mp4")
    Path.wildcard(pattern)
  end

  defp immediate_check do
    send(self(), :check_for_files)
  end

  defp schedule_check do
    Process.send_after(self(), :check_for_files, 5_000)
  end
end
