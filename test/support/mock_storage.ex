defmodule Capsule.Storages.Mock do
  alias Capsule.{Storage, Encapsulation}

  @behaviour Storage

  @impl Storage
  def put(_upload, opts \\ []) do
    encapsulation = %Encapsulation{id: opts[:id], storage: __MODULE__}

    {:ok, encapsulation}
  end

  @impl Storage
  def delete(%Encapsulation{}, _opts \\ []), do: {:ok, nil}

  @impl Storage
  def read(%Encapsulation{}, _opts \\ []), do: {:ok, "mock file contents"}
end
