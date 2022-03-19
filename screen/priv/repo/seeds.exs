# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Screen.Repo.insert!(%Screen.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Screen.Cameras

camera = Cameras.checkin("cam1")

seed_clips =
  Path.join([__DIR__, "../../tmp/seeds/*.mp4"])
  |> Path.wildcard()

Enum.each(seed_clips, fn path ->
  filename = Path.basename(path)
  [timestamp, "mp4"] = String.split(filename, ".")
  %File.Stat{size: bytesize} = File.stat!(path)

  {:ok, clip} =
    Cameras.create_clip(camera, %{
      timestamp: timestamp,
      bytesize: bytesize
    })

  Cameras.save_clip_file(clip, path)
end)
