defmodule Capsule do
  alias Capsule.Encapsulation

  def add_metadata(%Encapsulation{} = encapsulation, data) do
    %{encapsulation | metadata: encapsulation.metadata |> Map.merge(data)}
  end

  def open(%Encapsulation{storage: module_name} = encapsulation) do
    storage =
      module_name
      |> String.replace_prefix("", "Elixir.")
      |> String.to_existing_atom()

    storage.open(encapsulation)
  end
end
