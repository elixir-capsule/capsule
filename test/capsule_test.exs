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
      File.write!("tmp/name", "data")

      assert {:ok, "data"} =
               Capsule.open(%Encapsulation{
                 id: "tmp/name",
                 storage: "Elixir.Capsule.Storages.Disk"
               })

      on_exit(fn -> File.rm!("tmp/name") end)
    end

    test "handles storage without Elixir prefix" do
      File.write!("tmp/name", "data")

      assert {:ok, "data"} =
               Capsule.open(%Encapsulation{
                 id: "tmp/name",
                 storage: "Capsule.Storages.Disk"
               })

      on_exit(fn -> File.rm!("tmp/name") end)
    end
  end
end
