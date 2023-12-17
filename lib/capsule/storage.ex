defmodule Capsule.Storage do
  alias Capsule.Upload

  @type option :: {atom(), any()}
  @type locator_id :: String.t()
  @type error :: {:error, String.t()}

  @callback read(locator_id, [option]) :: {:ok, binary()} | error
  @callback read(locator_id) :: {:ok, binary()} | error

  @callback stream!(locator_id, [option]) :: Enumerable.t()
  @callback stream!(locator_id) :: Enumerable.t()

  @callback put(Upload.t(), [option]) :: {:ok, locator_id} | error
  @callback put(Upload.t()) :: {:ok, locator_id} | error

  @callback delete(locator_id, [option]) :: :ok | error
  @callback delete(locator_id) :: :ok | error
end
