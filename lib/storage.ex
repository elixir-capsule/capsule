defmodule Capsule.Storage do
  alias Capsule.{Upload, Encapsulation}

  @callback put(Upload.t(), force: boolean) :: {:ok, Encapsulation.t()} | {:error, String.t()}
  @callback delete(Encapsulation.t()) :: :ok | {:error, String.t()}
end
