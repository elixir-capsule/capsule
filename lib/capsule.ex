defmodule Capsule do
  alias Capsule.Encapsulation
  alias Capsule.Errors.InvalidStorage

  def add_metadata(%Encapsulation{} = encapsulation, data) do
    %{encapsulation | metadata: encapsulation.metadata |> Map.merge(data)}
  end

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
