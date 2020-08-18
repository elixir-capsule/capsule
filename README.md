# capsule
Upload and store files in Elixir apps.

~Totally naked, no tests.~ Now with some tests!

NSFP

## take the purple pill

Capsule intentionally strips file storage logic down to its most composable parts and lets you decide how you want to use them. Here's a working example with an Ecto schema stored on a DB table, saving the file onto a local file system and extracting some metadata:

```
  def create_attachment(url) do
    Multi.new()
    |> Multi.run(:upload, fn _, _ -> Disk.put(URI.parse(url)) end)
    |> Multi.insert(:attachment, fn %{upload: file_data} ->
      Source.changeset(%Attachment{}, %{
        file_data: file_data |> Map.from_struct(),
        name: file_data.metadata.name,
        file_type: if(Path.extname(file_data.id) == ".pdf", do: :pdf, else: :txt)
      })
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{source: source}} ->
        {:ok, source}

      {:error, :upload, error, _changes} ->
        {:error, "File upload error: #{error}"}
    end
  end
```

## roadmap

* ~at least 1 test~
* more tests
* more storages
* more uploader implementations
* better readme
