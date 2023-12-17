defmodule Capsule.Storages.Mock do
  alias Capsule.Storage

  @behaviour Storage

  @impl Storage
  def put(_id, opts \\ []) do
    {:ok, Keyword.get(opts, :id, to_string(:erlang.ref_to_list(:erlang.make_ref())))}
  end

  @impl Storage
  def delete(_id, _opts \\ []), do: {:ok, nil}

  @impl Storage
  def read(_id, _opts \\ []), do: {:ok, "mock file contents"}

  @impl Storage
  def stream!(_id, _opts \\ []),
    do: "mock file contents" |> StringIO.open() |> elem(1) |> IO.stream(:line)
end
