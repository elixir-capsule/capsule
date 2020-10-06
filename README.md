# capsule

Upload and store files in Elixir apps with minimal (currently zero) dependencies.

[![hex package](https://img.shields.io/hexpm/v/capsule.svg)](https://hex.pm/packages/capsule)
[![CI status](https://github.com/elixir-capsule/capsule/workflows/CI/badge.svg)](https://github.com/elixir-capsule/capsule/actions)

:warning: Capsule is experimental and still in active development. Accepting file uploads introduces specific security vulnerabilities. Use at your own risk.

## not-so-jagged little pill

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

{:ok, contents} = Capsule.read(file)
```

<sup>1</sup> *See [integrations](integrations) for streamlined use with Ecto.*

## concepts

There are three main concepts in capsule: storage, upload, and the special one, "encapsulation."

*Note: As of version 0.6 Capsule all built-in storages and uploads except for Encapsulation have been moved to [elixir-capsule/supplement](https://github.com/elixir-capsule/supplement).*

### storage

A "storage" is a [behaviour](https://elixirschool.com/en/lessons/advanced/behaviours/) that implements the following "file-like" callbacks:

* read
* put
* copy
* delete

Implementing your own storage is as easy as creating a module that quacks this way. Each callback should accept an optional list of options as the last arg. Which options are supported is up to the module that implements the callbacks.

### upload

Upload is a [protocol](https://elixir-lang.org/getting-started/protocols.html) consisting of the following two functions:

* contents
* name

A storage uses this interface to figure how to extract the file data from a given struct and how to identify it. See `Capsule.Encapsulation` for an example of how this protocol can be implemented.

### encapsulation

Encapsulations are the mediators between storages and uploads. They represent the result of `put`ting an upload into a storage. They contain a unique id, the name of the storage to which the file was uploaded, the size, and a map of user defined metadata.

`%{id: "/path/to/file.jpg", storage: "YourStorage", size: 34100, metadata: %{}} = YourStorage.put(some_upload)`

Encapsulation also implements the upload protocol, which means moving a file from one storage to another is lemon-squeezy:

```
old_file = %{id: "/path/to/file.jpg", storage: "YourStorage", size: 34100, metadata: %{}}
new_file = OtherStorage.put(old_file)`
```

Note: you'll still need to take care of cleaning up the old file:

`YourStorage.delete(encapsulation)`

## integrations

* [Ecto](https://github.com/elixir-capsule/capsule_ecto)

That's it! Happy uploading.
