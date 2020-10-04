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

  describe "open/1" do
    test "opens file in storage" do
      assert {:ok, _} =
               Capsule.open(%Encapsulation{
                 id: "name",
                 storage: "Elixir.Capsule.Storages.Mock"
               })
    end

    test "handles storage without Elixir prefix" do
      assert {:ok, _} =
               Capsule.open(%Encapsulation{
                 id: "name",
                 storage: "Capsule.Storages.Mock"
               })
    end
  end
end
