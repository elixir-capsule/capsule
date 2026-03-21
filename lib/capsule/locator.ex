defmodule Capsule.Locator do
  @moduledoc """
  A struct that identifies an uploaded file by its storage location.

  Contains the file's ID within the storage backend, the storage module, and
  arbitrary metadata.
  """

  defstruct [:id, :storage, metadata: %{}]

  @type t() :: %__MODULE__{
          id: String.t(),
          storage: String.t(),
          metadata: map()
        }

  @doc """
  Same as `new/1`, but raises `Capsule.Errors.InvalidLocator` instead of returning an error tuple.
  """
  @spec new!(keyword() | map()) :: t()
  def new!(attrs) do
    case new(attrs) do
      {:ok, locator} -> locator
      {:error, error} -> raise(Capsule.Errors.InvalidLocator, error)
    end
  end

  @doc """
  Creates a new `Capsule.Locator` from the given attributes.
  Returns `{:ok, locator}` on success or `{:error, reason}` on failure.

  Accepts a keyword list or map with `:id` and `:storage` keys, or string keys
  `"id"` and `"storage"`.
  """
  @spec new(keyword() | map()) :: {:ok, t()} | {:error, String.t()}
  def new(attrs) when is_list(attrs),
    do: attrs |> Map.new() |> new()

  def new(map = %{"id" => id, "storage" => storage}),
    do: new(%{id: id, storage: storage, metadata: Map.get(map, "metadata")})

  def new(map) when is_map_key(map, :id) and is_map_key(map, :storage) do
    __MODULE__
    |> struct(map)
    |> validate()
  end

  def new(_), do: {:error, "data must contain id and storage keys"}

  defp validate(%{id: id}) when not is_binary(id), do: {:error, "id must be binary"}

  defp validate(%{storage: storage})
       when (not is_binary(storage) and not is_atom(storage)) or is_nil(storage),
       do: {:error, "storage must be string or atom"}

  defp validate(struct), do: {:ok, struct}
end
