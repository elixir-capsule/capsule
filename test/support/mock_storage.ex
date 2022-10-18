defmodule Capsule.Storages.Mock do
  alias Capsule.{Storage, Locator}

  @behaviour Storage

  @impl Storage
  def put(_upload, opts \\ []) do
    locator = %Locator{id: opts[:id], storage: __MODULE__}

    {:ok, locator}
  end

  @impl Storage
  def delete(%Locator{}, _opts \\ []), do: {:ok, nil}

  @impl Storage
  def read(%Locator{}, _opts \\ []), do: {:ok, "mock file contents"}
end
