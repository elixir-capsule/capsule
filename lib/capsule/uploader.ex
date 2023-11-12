defmodule Capsule.Uploader do
  alias Capsule.Locator

  @type storage :: atom()
  @type option :: {atom(), any()}

  @callback store(any(), storage, [option]) :: {:ok, Locator.t()} | {:error, any()}
  @callback build_options(any(), storage, [option]) :: [option]
  @callback build_metadata(Locator.t(), storage, [option]) :: Keyword.t() | map()

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @behaviour Capsule.Uploader

      @storages Keyword.fetch!(opts, :storages)

      @impl Capsule.Uploader
      def store(upload, storage_key, opts \\ []) do
        storage = fetch_storage!(upload, storage_key)

        upload
        |> storage.put(build_options(upload, storage_key, opts))
        |> case do
          {:ok, id} ->
            locator =
              Capsule.add_metadata(
                Locator.new!(id: id, storage: storage),
                build_metadata(upload, storage_key, opts)
              )

            {:ok, locator}

          error_tuple ->
            error_tuple
        end
      end

      @impl Capsule.Uploader
      def build_metadata(_, _, _), do: []

      @impl Capsule.Uploader
      def build_options(_, _, instance_opts), do: instance_opts

      defp fetch_storage!(upload, storage) do
        @storages
        |> case do
          {m, f, a} -> apply(m, f, [upload | a])
          storages when is_list(storages) -> storages
        end
        |> Keyword.fetch(storage)
        |> case do
          {:ok, storage} ->
            storage

          _ ->
            raise "#{storage} not found in #{__MODULE__} storages. Available: #{inspect(Keyword.keys(@storages))}"
        end
      end

      defoverridable build_options: 3, build_metadata: 3
    end
  end
end
