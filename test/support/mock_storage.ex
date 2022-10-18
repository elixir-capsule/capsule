defmodule Capsule.Storages.Mock do
  alias Capsule.Storage

  @behaviour Storage

  @impl Storage
  def put(_id, opts \\ []) do
    {:ok, opts[:id]}
  end

  @impl Storage
  def delete(_id, _opts \\ []), do: {:ok, nil}

  @impl Storage
  def read(_id, _opts \\ []), do: {:ok, "mock file contents"}
end
