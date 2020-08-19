defmodule Capsule do
  alias Capsule.Encapsulation

  def add_metadata(%Encapsulation{} = encapsulation, data) do
    %{encapsulation | metadata: encapsulation.metadata |> Map.merge(data)}
  end
end
