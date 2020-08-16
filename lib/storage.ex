defmodule Capsule.Storage do
  alias Capsule.{Upload, Encapsulation}

  @callback put(Upload.t()) :: {:ok, Encapsulation.t()} | {:error, String.t()}
  @callback delete(Encapsulation.t()) :: :ok | {:error, String.t()}
end
