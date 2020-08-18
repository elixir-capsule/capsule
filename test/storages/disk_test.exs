defmodule Capsule.Storages.DiskTest do
  use ExUnit.Case
  doctest Capsule

  alias Capsule.Storages.Disk
  alias Capsule.{Encapsulation, MockUpload}

  describe "put/1" do
    test "returns success tuple" do
      assert {:ok, %Encapsulation{}} = Disk.put(%MockUpload{})

      on_exit(fn -> File.rm!("tmp/hi") end)
    end

    test "writes file to destination" do
      Disk.put(%MockUpload{destination: "subdir/name"})

      assert File.exists?("tmp/subdir/name")

      on_exit(fn -> File.rm!("tmp/subdir/name") end)
    end

    test "returns error when file already exists" do
      File.write!("tmp/name", "data")

      assert {:error, _} = Disk.put(%MockUpload{destination: "name"})

      on_exit(fn -> File.rm!("tmp/name") end)
    end

    test "overwrites existing file when force is set to true" do
      File.write!("tmp/name", "data")

      Disk.put(%MockUpload{destination: "name", content: "new"}, force: true)

      assert "new" = File.read!("tmp/name")

      on_exit(fn -> File.rm!("tmp/name") end)
    end
  end

  describe "open/1" do
    test "returns success tuple with data" do
      File.write!("tmp/name", "data")

      assert {:ok, "data"} = Disk.open(%Encapsulation{id: "tmp/name"})
    end
  end
end
