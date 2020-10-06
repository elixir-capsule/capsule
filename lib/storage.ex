defmodule Capsule.Storage do
  alias Capsule.{Upload, Encapsulation}

  @type option :: {atom(), any()}

  @callback read(Encapsulation.t(), [option]) :: {:ok, binary()} | {:error, String.t()}
  @callback put(Upload.t(), [option]) :: {:ok, Encapsulation.t()} | {:error, String.t()}
  @callback copy(Upload.t(), Path.t(), [option]) ::
              {:ok, Encapsulation.t()} | {:error, String.t()}
  @callback delete(Encapsulation.t(), [option]) :: :ok | {:error, String.t()}
end
