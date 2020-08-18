defmodule Capsule.Storages.Disk do
  alias Capsule.{Storage, Upload, Encapsulation}

  @behaviour Storage

  @impl Storage
  def put(upload, opts \\ []) do
    with path <- Upload.destination(upload),
         destination <- qualified_path(path),
         true <-
           !File.exists?(destination) || opts[:force] ||
             {:error, "File already exists at upload destination"},
         {:ok, io} <- Upload.contents(upload) do
      create_path!(destination)

      File.write!(destination, io)

      encapsulation = %Encapsulation{id: path, storage: __MODULE__}

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
  def move(%Encapsulation{id: id} = encapsulation, path) do
    qualified_path(path)
    |> create_path!

    qualified_path(id)
    |> File.rename(qualified_path(path))
    |> case do
      :ok -> {:ok, encapsulation |> Map.replace!(:id, path)}
      error_tuple -> error_tuple
    end
  end

  @impl Storage
  def delete(%Encapsulation{id: id}) when is_binary(id) do
    qualified_path(id)
    |> File.rm()
    |> case do
      :ok -> {:ok, nil}
      {:error, error} -> {:error, "Could not remove file: #{error}"}
    end
  end

  @impl Storage
  def open(%Encapsulation{id: id}), do: File.read(id)

  defp config(), do: Application.fetch_env!(:capsule, __MODULE__)

  defp qualified_path(path) do
    config()[:root_dir]
    |> Path.join(path)
  end

  defp create_path!(path) do
    path |> Path.dirname() |> File.mkdir_p!()
  end
end
