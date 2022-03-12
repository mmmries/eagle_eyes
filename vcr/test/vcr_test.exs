defmodule VcrTest do
  use ExUnit.Case
  doctest Vcr

  test "greets the world" do
    assert Vcr.hello() == :world
  end
end
