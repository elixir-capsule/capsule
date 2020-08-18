defmodule Capsule.Storages.Disk do
  alias Capsule.{Storage, Upload, Encapsulation}

  @behaviour Storage

  @impl Storage
  def put(upload, opts \\ []) do
    with destination <- Upload.destination(upload),
         destination <-
           config()[:root_dir]
           |> Path.join(destination),
         true <-
           !File.exists?(destination) || opts[:force] ||
             {:error, "File already exists at upload destination"},
         {:ok, io} <- Upload.contents(upload) do
      destination |> Path.dirname() |> File.mkdir_p!()

      File.write!(destination, io)

      encapsulation = %Encapsulation{id: destination, storage: __MODULE__}

      {:ok, encapsulation}
    end
    |> case do
      {:error, error} ->
        {:error, "Could not store file: #{error}"}

      success_tuple ->
        success_tuple
    end
  end

  @impl Storage
  def delete(%Encapsulation{id: id}) when is_binary(id) do
    case File.rm(id) do
      :ok -> {:ok, nil}
      {:error, error} -> {:error, "Could not remove file: #{error}"}
    end
  end

  @impl Storage
  def open(%Encapsulation{id: id}), do: File.read(id)

  defp config(), do: Application.fetch_env!(:capsule, __MODULE__)
end
