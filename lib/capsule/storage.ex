defmodule Capsule.Storage do
  alias Capsule.{Upload, Locator}

  @type option :: {atom(), any()}

  @callback read(Locator.t(), [option]) :: {:ok, binary()} | {:error, String.t()}
  @callback put(Upload.t(), [option]) :: {:ok, Locator.t()} | {:error, String.t()}
  @callback delete(Locator.t(), [option]) :: :ok | {:error, String.t()}
end
