defmodule Capsule.Storage do
  alias Capsule.Upload

  @type option :: {atom(), any()}
  @type locator_id :: String.t()

  @callback read(locator_id, [option]) :: {:ok, binary()} | {:error, String.t()}
  @callback read(locator_id) :: {:ok, binary()} | {:error, String.t()}
  @callback put(Upload.t(), [option]) :: {:ok, locator_id} | {:error, String.t()}
  @callback put(Upload.t()) :: {:ok, locator_id} | {:error, String.t()}
  @callback delete(locator_id, [option]) :: :ok | {:error, String.t()}
  @callback delete(locator_id) :: :ok | {:error, String.t()}
end
