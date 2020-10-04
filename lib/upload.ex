defprotocol Capsule.Upload do
  @spec contents(struct()) :: {:ok, iodata()} | {:error, String.t()}
  def contents(upload)

  @spec name(struct()) :: String.t()
  def name(upload)
end

defimpl Capsule.Upload, for: Capsule.Encapsulation do
  defdelegate contents(encapsulation), to: Capsule, as: :open

  def name(%{metadata: %{name: name}}), do: name
  def name(%{id: id}), do: id
end
