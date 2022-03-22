defmodule Capsule do
  alias Capsule.Encapsulation
  alias Capsule.Errors.InvalidStorage

  def add_metadata(%Encapsulation{} = encapsulation, key, val),
    do: add_metadata(encapsulation, %{key => val})

  def add_metadata(%Encapsulation{} = encapsulation, data) when is_list(data),
    do: add_metadata(encapsulation, Enum.into(data, %{}))

  def add_metadata(%Encapsulation{} = encapsulation, data),
    do: %{encapsulation | metadata: encapsulation.metadata |> Map.merge(data)}

  def storage!(%Encapsulation{storage: module_name}) when is_binary(module_name) do
    module_name
    |> String.replace_prefix("", "Elixir.")
    |> String.replace_prefix("Elixir.Elixir", "Elixir")
    |> String.to_existing_atom()
  rescue
    ArgumentError -> raise InvalidStorage
  end

  @deprecated "Use Capsule.storage!/1 and Capsule.Storage.delete/1"
  def read(%Encapsulation{storage: module_name} = encapsulation) when is_binary(module_name) do
    storage =
      try do
        module_name
        |> String.replace_prefix("", "Elixir.")
        |> String.replace_prefix("Elixir.Elixir", "Elixir")
        |> String.to_existing_atom()
      rescue
        ArgumentError -> raise InvalidStorage
      end

    storage.read(encapsulation)
  end

  def read(encapsulation), do: %Encapsulation{encapsulation | storage: ""} |> read()
end
