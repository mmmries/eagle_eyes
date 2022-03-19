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
    # use an atomic move to put it in the converted directory
    # this way we don't have to worry about trying to send a partially
    # converted file
    new_basename = Path.basename(filepath, ".h264") <> ".mp4"
    temp_location = Path.join([Cam.raw_clip_directory(), new_basename])
    destination = Path.join([Cam.converted_clip_directory(), new_basename])

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
      temp_location
    ]

    {_output, 0} = System.cmd("ffmpeg", args, stderr_to_stdout: true)
    File.rm!(filepath)
    File.rename!(temp_location, destination)
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
