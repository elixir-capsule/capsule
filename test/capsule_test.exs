defmodule CapsuleTest do
  use ExUnit.Case
  doctest Capsule

  alias Capsule.Encapsulation

  describe "add_metadata/2 with map" do
    test "merges data into existing metadata" do
      assert %{metadata: %{a: 1, b: 2}} =
               Capsule.add_metadata(%Encapsulation{metadata: %{a: 1}}, %{b: 2})
    end
  end

  describe "add_metadata/2 with list" do
    test "merges data into existing metadata" do
      assert %{metadata: %{a: 1, b: 2}} =
               Capsule.add_metadata(%Encapsulation{metadata: %{a: 1}}, b: 2)
    end
  end

  describe "add_metadata/3" do
    test "merges val into existing metadata at given key" do
      assert %{metadata: %{a: 1, b: 2}} =
               Capsule.add_metadata(%Encapsulation{metadata: %{a: 1}}, :b, 2)
    end
  end

  describe "read/1" do
    test "reads stored file contents into memory" do
      assert {:ok, _} =
               Capsule.read(%Encapsulation{
                 id: "name",
                 storage: "Elixir.Capsule.Storages.Mock"
               })
    end

    test "handles storage without Elixir prefix" do
      assert {:ok, _} =
               Capsule.read(%Encapsulation{
                 id: "name",
                 storage: "Capsule.Storages.Mock"
               })
    end

    test "raises error on missing storage" do
      assert_raise Capsule.Errors.InvalidStorage, fn ->
        Capsule.read(%Encapsulation{
          id: "name"
        })
      end
    end

    test "raises error on invalid storage" do
      assert_raise Capsule.Errors.InvalidStorage, fn ->
        Capsule.read(%Encapsulation{
          id: "name",
          storage: "what"
        })
      end
    end
  end
end
