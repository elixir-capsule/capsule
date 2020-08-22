defmodule Capsule.MockUpload do
  defstruct content: "Hi, I'm a file", name: "hi"

  defimpl Capsule.Upload do
    def contents(mock), do: {:ok, mock.content}

    def name(mock), do: mock.name
  end
end
