defmodule Capsule.Locator do
  defstruct [:id, :storage, metadata: %{}]

  @type t() :: %__MODULE__{
          id: String.t(),
          storage: String.t(),
          metadata: map()
        }

  def new(map = %{"id" => id, "storage" => storage}),
    do: new(%{id: id, storage: storage, metadata: Map.get(map, "metadata")})

  def new(map) when is_map_key(map, :id) and is_map_key(map, :storage),
    do: {:ok, struct(__MODULE__, map)}

  def new(_), do: {:error, "data must contain id and storage keys"}
end
