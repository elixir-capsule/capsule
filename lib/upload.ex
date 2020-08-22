defprotocol Capsule.Upload do
  @spec contents(struct()) :: {:ok, iodata()} | {:error, String.t()}
  def contents(upload)

  @spec name(struct()) :: String.t()
  def name(upload)
end

defimpl Capsule.Upload, for: URI do
  def contents(name) do
    case :httpc.request(name |> URI.to_string() |> String.to_charlist()) do
      {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, body}} -> {:ok, body}
      {:error, {reason}} -> {:error, reason}
    end
  end

  def name(%{path: path}), do: Path.basename(path)
end
