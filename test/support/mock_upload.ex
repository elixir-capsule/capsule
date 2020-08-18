defmodule Capsule.MockUpload do
  defstruct content: "Hi, I'm a file", destination: "hi"

  defimpl Capsule.Upload do
    def contents(upload), do: {:ok, upload.content}

    def destination(upload), do: upload.destination
  end
end
