defprotocol Capsule.Upload do
  @spec read(struct()) :: {:ok, iodata()} | {:error, String.t()}
  def read(upload)

  @spec location(struct()) :: Path.t()
  def location(upload)
end

defimpl Capsule.Upload, for: URI do
  def read(uri) do
    case :httpc.request(uri |> URI.to_string() |> String.to_charlist()) do
      {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, body}} -> {:ok, body}
      {:error, _} = error_tuple -> error_tuple
    end
  end

  def location(%{path: path}), do: path
end
