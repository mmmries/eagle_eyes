defmodule Cam.Converter do
  use GenServer

  def start_link(nil) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl GenServer
  def init(nil) do
    immediate_check()
    {:ok, nil}
  end

  @impl GenServer
  def handle_info(:check_for_files, state) do
    case get_file_list() do
      [] ->
        schedule_check()

      [first_file | _rest] ->
        convert_file(first_file)
        immediate_check()
    end

    {:noreply, state}
  end

  def convert_file(filepath) do
    destination =
      Cam.converted_clip_directory()
      |> Path.join(Path.basename(filepath, ".h264") <> ".mp4")

    args = [
      "-loglevel",
      "quiet",
      "-y",
      "-framerate",
      "24",
      "-i",
      filepath,
      "-c",
      "copy",
      destination
    ]

    {_output, 0} = System.cmd("ffmpeg", args, stderr_to_stdout: true)
    File.rm!(filepath)
  end

  def get_file_list do
    pattern = Path.join(Cam.raw_clip_directory(), "*.h264")
    Path.wildcard(pattern)
  end

  defp immediate_check do
    send(self(), :check_for_files)
  end

  defp schedule_check do
    Process.send_after(self(), :check_for_files, 5_000)
  end
end
