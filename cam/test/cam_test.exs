defmodule CamTest do
  use ExUnit.Case
  doctest Cam

  test "greets the world" do
    assert Cam.hello() == :world
  end
end
