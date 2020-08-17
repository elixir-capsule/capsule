defmodule Capsule.MockUpload do
  defstruct content: "Hi, I'm a file", location: "hi"

  defimpl Capsule.Upload do
    def read(upload), do: {:ok, upload.content}

    def location(upload), do: upload.location
  end
end
