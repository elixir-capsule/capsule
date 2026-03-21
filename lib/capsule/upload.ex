defprotocol Capsule.Upload do
  @moduledoc """
  Protocol for reading upload contents and name from any data structure.
  """

  @doc """
  Returns the contents of the upload as an iodata binary.
  """
  @spec contents(struct()) :: {:ok, iodata()} | {:error, String.t()}
  def contents(upload)

  @doc """
  Returns the name of the upload. Falls back to the locator ID if no name is set in metadata.
  """
  @spec name(struct()) :: String.t()
  def name(upload)
end

defimpl Capsule.Upload, for: Capsule.Locator do
  def contents(locator), do: Capsule.storage!(locator).read(locator.id)

  def name(%{metadata: %{name: name}}), do: name
  def name(%{id: id}), do: id
end
