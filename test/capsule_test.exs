defmodule CapsuleTest do
  use ExUnit.Case
  doctest Capsule

  alias Capsule.Locator

  describe "add_metadata/2 with map" do
    test "merges data into existing metadata" do
      assert %{metadata: %{a: 1, b: 2}} =
               Capsule.add_metadata(%Locator{metadata: %{a: 1}}, %{b: 2})
    end
  end

  describe "add_metadata/2 with list" do
    test "merges data into existing metadata" do
      assert %{metadata: %{a: 1, b: 2}} = Capsule.add_metadata(%Locator{metadata: %{a: 1}}, b: 2)
    end
  end

  describe "add_metadata/3" do
    test "merges val into existing metadata at given key" do
      assert %{metadata: %{a: 1, b: 2}} = Capsule.add_metadata(%Locator{metadata: %{a: 1}}, :b, 2)
    end
  end

  describe "storage!/1 with binary storage" do
    test "returns storage module" do
      assert Capsule.Storages.Mock =
               Capsule.storage!(%Locator{storage: "Elixir.Capsule.Storages.Mock"})
    end

    test "handles storage without Elixir prefix" do
      assert Capsule.Storages.Mock = Capsule.storage!(%Locator{storage: "Capsule.Storages.Mock"})
    end

    test "raises error on invalid storage" do
      assert_raise Capsule.Errors.InvalidStorage, fn ->
        Capsule.storage!(%Locator{storage: "what"})
      end
    end
  end

  describe "storage!/1 with atom storage" do
    test "returns storage module" do
      assert Capsule.Storages.Mock =
               Capsule.storage!(%Locator{storage: Capsule.Storages.Mock})
    end

    test "returns module" do
      assert Capsule.Storages.Mock = Capsule.storage!(%Locator{storage: "Capsule.Storages.Mock"})
    end
  end
end
