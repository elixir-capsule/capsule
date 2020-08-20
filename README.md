# capsule

Upload and store files in Elixir apps with minimal (currently zero) dependencies.


## take the purple pill

Capsule intentionally strips file storage logic down to its most composable parts and lets you decide how you want to use them. Here's a complete working example with an Ecto schema, that saves the file onto a local file system and extracts some metadata:

```
  def create_attachment(url) do
    Multi.new()
    |> Multi.run(:upload, fn _, _ ->
      Disk.put(URI.parse(url), prefix: :crypto.hash(:md5, [user.id, url]) |> Base.encode16())
    end)
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

## concepts

There are three main concepts in capsule: storage, upload, and the special one, "encapsulation."

### storage

A "storage" is [behaviour](https://elixirschool.com/en/lessons/advanced/behaviours/) that implements the following "file-like" callbacks:

* open
* put
* move
* delete

Currently, capsule only supports the Disk storage, although Memory is planned. But implementing your own storage is as easy as creating a module that quacks this way.

### upload

Upload is a [protocol](https://elixir-lang.org/getting-started/protocols.html) consisting of the following two functions:

* contents
* destination

A storage uses this interface to figure how to extract the file data from a given struct and where to put it. Currently capsule only implements the upload protocol for the URI module, because URI is a standard lib. The following is the example of how you might implement the protocol for Plug.Upload:

```
defimpl Capsule.Upload, for: Plug.Upload do
  def contents(%{path: path}) do
    case File.read(path) do
      {:error, reason} -> {:error, "Could not read path: #{reason}"}
      success_tuple -> success_tuple
    end
  end

  def destination(%{filename: name}), do: name
end
```

*obamaface.jpg*

### encapsulation

Encapsulations are the mediators between storages and uploads. They represent the result of `put`ting an upload into a storage. However, they also implement the upload protocol themselves, which means moving a file from one storage to another is as easy as this:

```
old_busted_encapsulation = Disk.put(upload)

new_shiny_encapsulation = YourCoolStorage.put(encapsulation)
```

Note: you'll still need to take care of cleaning up the old file (or some poor async Task you probably underpay):

```
Disk.delete(old_busted_encapsulation)
```

That's it! Happy uploading.
