defmodule Capsule.LocatorTest do
  use ExUnit.Case
  doctest Capsule

  alias Capsule.Locator

  describe "new/1 with map with required string keys" do
    test "returns struct" do
      assert {:ok, %Locator{}} = Locator.new(%{"id" => "fake", "storage" => "Fake"})
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
end
