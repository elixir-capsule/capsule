defmodule CapsuleTest do
  use ExUnit.Case
  doctest Capsule

  alias Capsule.Encapsulation

  describe "add_metadata/2" do
    test "merges data into existing metadata" do
      assert %{metadata: %{a: 1, b: 2}} =
               Capsule.add_metadata(%Encapsulation{metadata: %{a: 1}}, %{b: 2})
    end
  end
end
