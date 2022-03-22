defprotocol Capsule.Upload do
  @spec contents(struct()) :: {:ok, iodata()} | {:error, String.t()}
  def contents(upload)

  @spec name(struct()) :: String.t()
  def name(upload)
end

defimpl Capsule.Upload, for: Capsule.Encapsulation do
  def contents(cap), do: Capsule.storage!(cap).read(cap)

  def name(%{metadata: %{name: name}}), do: name
  def name(%{id: id}), do: id
end
