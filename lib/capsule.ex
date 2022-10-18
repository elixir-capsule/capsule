defmodule Capsule do
  alias Capsule.Locator
  alias Capsule.Errors.InvalidStorage

  def add_metadata(%Locator{} = locator, key, val),
    do: add_metadata(locator, %{key => val})

  def add_metadata(%Locator{} = locator, data) when is_list(data),
    do: add_metadata(locator, Enum.into(data, %{}))

  def add_metadata(%Locator{} = locator, data),
    do: %{locator | metadata: locator.metadata |> Map.merge(data)}

  def storage!(%Locator{storage: module_name}) when is_binary(module_name) do
    module_name
    |> String.replace_prefix("", "Elixir.")
    |> String.replace_prefix("Elixir.Elixir", "Elixir")
    |> String.to_existing_atom()
  rescue
    ArgumentError -> raise InvalidStorage
  end
end
