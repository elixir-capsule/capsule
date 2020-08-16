defmodule CapsuleTest do
  use ExUnit.Case
  doctest Capsule

  test "greets the world" do
    assert Capsule.hello() == :world
  end
end
