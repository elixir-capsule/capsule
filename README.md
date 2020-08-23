# capsule

Upload and store files in Elixir apps with minimal (currently zero) dependencies.

[![hex package](https://img.shields.io/hexpm/v/capsule.svg)](https://hex.pm/packages/capsule)
[![CI status](https://github.com/elixir-capsule/capsule/workflows/CI/badge.svg)](https://github.com/elixir-capsule/capsule/actions)

:warning: Capsule is experimental and still in active development---it is *not* production ready. Accepting file uploads introduces security vulnerabilities. The API is *expected* to change. Use at your own risk.

## Not-so-jagged little pill

Capsule intentionally strips file storage logic down to its most composable parts and lets you decide how you want to use them. It is intentionally agnostic about versions, transformation, validations, etc. Most of the convenience offered by other libraries around these features comes at the cost of locking in dependence on specific tools and hiding complexity. Capsule puts a premium on simplicity and explicitness.

So what does it do? Here's a theoretical example of use with an Ecto<sup>1</sup> schema, that saves the file onto a local file system and extracts some metadata before attaching the file:

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

{:ok, contents} = Capsule.open(file)
```

<sup>1</sup> *See below for optional integration with Ecto.*

## concepts

There are three main concepts in capsule: storage, upload, and the special one, "encapsulation."

### storage

A "storage" is a [behaviour](https://elixirschool.com/en/lessons/advanced/behaviours/) that implements the following "file-like" callbacks:

* open
* put
* move
* delete

Currently, capsule only supports the [Disk storage](#disk). But implementing your own storage is as easy as creating a module that quacks this way.

### upload

Upload is a [protocol](https://elixir-lang.org/getting-started/protocols.html) consisting of the following two functions:

* contents
* name

A storage uses this interface to figure how to extract the file data from a given struct and how to identify it. Currently capsule only implements the upload protocol for the URI module, because URI is a standard lib. The following is the example of how you might implement the protocol for `Plug.Upload`:

```
defimpl Capsule.Upload, for: Plug.Upload do
  def contents(%{path: path}) do
    case File.read(path) do
      {:error, reason} -> {:error, "Could not read path: #{reason}"}
      success_tuple -> success_tuple
    end
  end

  def name(%{filename: name}), do: name
end
```

*obamaface.jpg*

### encapsulation

Encapsulations are the mediators between storages and uploads. They represent the result of `put`ting an upload into a storage. However, they also implement the upload protocol themselves, which means moving a file from one storage to another is as easy as this:

```
old_busted_encapsulation = Disk.put(upload)

new_shiny_encapsulation = YourCoolStorage.put(encapsulation)
```

Note: you'll still need to take care of cleaning up the old file (or pass the work on to some poor async Task):

```
Disk.delete(old_busted_encapsulation)
```

## storages

Every capsule storage should behave in a similar, predictable, and thus transparent way. For example, every storage must implement `put/1`. However, a storage may implement `put/2` to allow any additional information it needs to be *optionally* passed. Additionally, a storage may respect specific configuration and retrieve the information that way.

Capsule ships with storage for saving uploads to the local filesystem: `Disk`. Documentation for configuration and options it supports is below.

### Disk

Since it is possible for files with the same name to be uploaded multiple times, Disk needs some additional info to uniquely identify the file. Disk *does not* overwrite files with the same name by default. To ensure an upload can be stored, the combination of the `Upload.name` and `prefix` should be unique.

#### configuration

* To set the root directory where files will be stored: `Application.put_env(:capsule, Capsule.Storages.Disk, root_dir: "tmp")`

#### options

* `prefix`: This should be a valid system path that will be appended to the root. If it does not exist, Disk will create it.
* `force`: If this option is set to a truthy value, Disk will overwrite any existing file at the derived path. Use with caution! :warning:

## integrations

* [Ecto](https://github.com/elixir-capsule/capsule_ecto)

That's it! Happy uploading.
