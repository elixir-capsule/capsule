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

    test "writes file to location" do
      Disk.put(%MockUpload{location: "subdir/name"})

      assert File.exists?("tmp/subdir/name")

      on_exit(fn -> File.rm!("tmp/subdir/name") end)
    end

    test "returns error when file already exists" do
      File.write!("tmp/name", "data")

      assert {:error, _} = Disk.put(%MockUpload{location: "name"})

      on_exit(fn -> File.rm!("tmp/name") end)
    end

    test "overwrites existing file when force is set to true" do
      File.write!("tmp/name", "data")

      Disk.put(%MockUpload{location: "name", content: "new"}, force: true)

      assert "new" = File.read!("tmp/name")

      on_exit(fn -> File.rm!("tmp/name") end)
    end
  end
end
