defmodule Capsule.Storages.Mock do
  alias Capsule.{Storage, Encapsulation}

  @behaviour Storage

  @impl Storage
  def put(_upload, opts \\ []) do
    encapsulation = %Encapsulation{id: opts[:id], size: opts[:size] || 0, storage: __MODULE__}

    {:ok, encapsulation}
  end

  @impl Storage
  def copy(%Encapsulation{} = encapsulation, path),
    do: {:ok, encapsulation |> Map.replace!(:id, path)}

  @impl Storage
  def delete(%Encapsulation{}), do: {:ok, nil}

  @impl Storage
  def open(%Encapsulation{}), do: {:ok, "mock file contents"}
end
