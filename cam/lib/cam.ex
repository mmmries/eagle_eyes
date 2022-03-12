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
end
