defmodule Capsule.UploadTest do
  use ExUnit.Case
  doctest Capsule

  alias Capsule.{Upload, Encapsulation}

  describe "Encapsulation" do
    test "name returns name metadata if present" do
      assert "test" = Upload.name(%Encapsulation{metadata: %{name: "test"}})
    end
  end
end
