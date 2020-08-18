defprotocol Capsule.Upload do
  @spec contents(struct()) :: {:ok, iodata()} | {:error, String.t()}
  def contents(upload)

  @spec destination(struct()) :: Path.t()
  def destination(upload)
end

defimpl Capsule.Upload, for: URI do
  def contents(uri) do
    case :httpc.request(uri |> URI.to_string() |> String.to_charlist()) do
      {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, body}} -> {:ok, body}
      {:error, {reason}} -> {:error, reason}
    end
  end

  def destination(%{path: path}), do: path
end
