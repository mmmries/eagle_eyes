defmodule Cam do
  def directories do
    [
      raw_clip_directory(),
      converted_clip_directory()
    ]
  end

  def raw_clip_directory do
    "/home/pi/clips"
  end

  def converted_clip_directory do
    "/home/pi/converted"
  end

  # this assumes we have an erlang node name like cam@cam1.riesd.com
  # it strips it down to "cam1" which is how the central hub identifies
  # each camera device
  def node_name do
    Node.self()
    |> Atom.to_string()
    |> String.split("@")
    |> Enum.at(1)
    |> String.split(".")
    |> hd()
  end
end
