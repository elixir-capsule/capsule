defmodule Capsule.LocatorTest do
  use ExUnit.Case
  doctest Capsule

  alias Capsule.Locator

  describe "new/1 with map with required string keys" do
    test "returns struct" do
      assert {:ok, %Locator{}} = Locator.new(%{"id" => "fake", "storage" => "Fake"})
    end
  end

  describe "new/1 with map with atom storage" do
    test "returns struct" do
      assert {:ok, %Locator{}} = Locator.new(%{id: "fake", storage: Capsule.Storages.Mock})
    end
  end

  describe "new/1 with map with required atom keys" do
    test "returns struct" do
      assert {:ok, %Locator{}} = Locator.new(%{id: "fake", storage: "Fake"})
    end
  end

  describe "new/1 with map missing keys" do
    test "returns struct" do
      assert {:error, _} = Locator.new(%{id: "fake"})
    end
  end

  describe "new/1 with map with invalid id type" do
    test "returns error" do
      assert {:error, _} = Locator.new(%{id: 5, storage: "fake"})
    end
  end

  describe "new/1 with map with nil storage" do
    test "returns error" do
      assert {:error, _} = Locator.new(%{id: "fake", storage: nil})
    end
  end

  describe "new! with nil id" do
    test "raises error" do
      assert_raise(Capsule.Errors.InvalidLocator, fn ->
        Locator.new!(%{"id" => nil})
      end)
    end
  end
end
