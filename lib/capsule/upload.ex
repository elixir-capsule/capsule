defprotocol Capsule.Upload do
  @spec contents(struct()) :: {:ok, iodata()} | {:error, String.t()}
  def contents(upload)

  @spec name(struct()) :: String.t()
  def name(upload)

  @spec path(struct()) :: String.t() | nil
  def path(upload)
end

defimpl Capsule.Upload, for: Capsule.Locator do
  def contents(locator), do: Capsule.storage!(locator).read(locator.id)

  def name(%{metadata: %{name: name}}), do: name
  def name(%{id: id}), do: id
end
