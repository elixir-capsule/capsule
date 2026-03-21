defmodule Capsule do
  @moduledoc """
  Core utilities for working with `Capsule.Locator` structs.
  """

  alias Capsule.Locator
  alias Capsule.Errors.InvalidStorage

  @doc """
  Convenience for `add_metadata/2` with a single key-value pair. The key is converted to a string.
  """
  @spec add_metadata(Locator.t(), atom() | String.t(), any()) :: Locator.t()
  def add_metadata(%Locator{} = locator, key, val),
    do: add_metadata(locator, %{to_string(key) => val})

  @doc """
  Merges the given metadata into the locator's metadata.
  Accepts a keyword list or map. Keys are converted to strings. Existing keys are overwritten.
  """
  @spec add_metadata(Locator.t(), keyword() | map()) :: Locator.t()
  def add_metadata(%Locator{} = locator, data) when is_list(data),
    do: add_metadata(locator, Map.new(data, fn {k, v} -> {to_string(k), v} end))

  def add_metadata(%Locator{} = locator, data),
    do: %{
      locator
      | metadata:
          data
          |> Map.new(fn {k, v} -> {to_string(k), v} end)
          |> Map.merge(locator.metadata, fn _, new_value, _ -> new_value end)
    }

  @doc """
  Returns the storage module for the given locator.
  Raises `Capsule.Errors.InvalidStorage` if the storage module cannot be resolved.
  """
  @spec storage!(Locator.t()) :: module()
  def storage!(%Locator{storage: module_name}) when is_binary(module_name) do
    module_name
    |> String.replace_prefix("", "Elixir.")
    |> String.replace_prefix("Elixir.Elixir", "Elixir")
    |> String.to_existing_atom()
  rescue
    ArgumentError -> raise InvalidStorage
  end

  def storage!(%Locator{storage: module_name}) when is_atom(module_name), do: module_name
end
