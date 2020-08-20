# capsule

Upload and store files in Elixir apps with minimal (currently zero) dependencies.


## take the purple pill

Capsule intentionally strips file storage logic down to its most composable parts and lets you decide how you want to use them. Here's a working example with an Ecto schema stored on a DB table, saving the file onto a local file system and extracting some metadata:

```
  def create_attachment(url) do
    Multi.new()
    |> Multi.run(:upload, fn _, _ -> Disk.put(URI.parse(url)) end)
    |> Multi.insert(:attachment, fn %{upload: file_data} ->
      Source.changeset(%Attachment{}, %{
        file_data: file_data |> Capsule.add_metadata(%{name: file_data.metadata.name}) |> Map.from_struct(),
      })
    end)
    |> Repo.transaction()
  end
```

Then to access your file:

```
%Attachment{file_data: file} = attachment

{:ok, iodata} = Capsule.open(file)
```
