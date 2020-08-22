defmodule Capsule.Storage do
  alias Capsule.{Upload, Encapsulation}

  @callback open(Encapsulation.t()) :: {:ok, binary()} | {:error, String.t()}
  @callback put(Upload.t(), force: boolean, prefix: Path.t()) ::
              {:ok, Encapsulation.t()} | {:error, String.t()}
  @callback move(Upload.t(), Path.t()) :: {:ok, Encapsulation.t()} | {:error, String.t()}
  @callback delete(Encapsulation.t()) :: :ok | {:error, String.t()}
end
