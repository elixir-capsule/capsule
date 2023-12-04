defmodule Capsule do
  alias Capsule.Locator
  alias Capsule.Errors.InvalidStorage

  def copy(locator, dest_storage, opts \\ []) 
  def copy(%Locator{storage: source_storage}, dest_storage, _opts) when source_storage==dest_storage do
    raise "Use `#{source_storage.clone/3}` when you want to clone a file on the same storage"
  end
  def copy(%Locator{id: id} = locator, dest_storage, opts) do
    source_storage = storage!(locator)

    id
    |> source_storage.stream(opts)
    |> dest_storage.put(Keyword.put(opts, :name, id))
    |> case do
          {:ok, id} ->
            locator =
              Capsule.add_metadata(
                Locator.new!(id: id, storage: dest_storage),
                %{copied_from: source_storage}
              )

            {:ok, locator}

          error_tuple ->
            error_tuple
        end
  end

  def add_metadata(%Locator{} = locator, key, val),
    do: add_metadata(locator, %{key => val})

  def add_metadata(%Locator{} = locator, data) when is_list(data),
    do: add_metadata(locator, Enum.into(data, %{}))

  def add_metadata(%Locator{} = locator, data),
    do: %{locator | metadata: locator.metadata |> Map.merge(data)}

  def storage!(%Locator{storage: module_name}) when is_binary(module_name) do
    module_name
    |> String.replace_prefix("", "Elixir.")
    |> String.replace_prefix("Elixir.Elixir", "Elixir")
    |> String.to_existing_atom()
  rescue
    ArgumentError -> raise InvalidStorage
  end

  def storage!(%Locator{storage: module_name}) when is_atom(module_name), do: module_name

end
