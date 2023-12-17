# Capsule

Upload and store files in Elixir apps with minimal (currently zero) dependencies.

[![hex package](https://img.shields.io/hexpm/v/capsule.svg)](https://hex.pm/packages/capsule)
[![CI status](https://github.com/elixir-capsule/capsule/workflows/CI/badge.svg)](https://github.com/elixir-capsule/capsule/actions)

:warning: Although I have been using it in production for over a year without issue, Capsule is experimental and still in active development. Accepting file uploads introduces specific security vulnerabilities. Use at your own risk.

## Concepts

Capsule intentionally strips file storage logic down to its most composable parts and lets you decide how you want to use them. These components are: [storage](#storage), [upload](#upload), [locator](#locator), and optionally, [uploader](#uploader), which provides a more ergonomic API for the other 3.

It is intentionally agnostic about versions, transformation, validations, etc. Most of the convenience offered by other libraries around these features comes at the cost of locking in dependence on specific tools and hiding complexity. Capsule puts a premium on simplicity and explicitness.

So what does it do? Here's a theoretical example of a use case with an Ecto<sup>1</sup> schema, which stores the file retrieved from a URL, along with some additional metadata:

```
  def create_attachment(upload, user) do
    Multi.new()
    |> Multi.run(:upload, fn _, _ ->
      YourStorage.put(upload, prefix: :crypto.hash(:md5, [user.id, url]) |> Base.encode16())
    end)
    |> Multi.insert(:attachment, fn %{upload: file_id} ->
      %Attachment{file_data: Locator.new!(id: file_id, storage: YourStorage, metadata: %{type: "document"})
    end)
    |> Repo.transaction()
  end
```

Then to access the file:

```
%Attachment{file_data: file} = attachment

{:ok, contents} = Disk.read(file.id)
```

<sup>1</sup> *See [integrations](#integrations) for streamlined use with Ecto.*

### Storage

A "storage" is a [behaviour](https://elixirschool.com/en/lessons/advanced/behaviours/) that implements the following "file-like" callbacks:

* read
* put
* delete
* stream!

Implementing your own storage is as easy as creating a module that quacks this way. Each callback should accept an optional list of options as the last arg. Which options are supported is up to the module that implements the callbacks.

### Upload

Upload is a [protocol](https://elixir-lang.org/getting-started/protocols.html) consisting of the following two functions:

* contents
* name

A storage uses this interface to figure how to extract the file data from a given struct and how to identify it. See `Capsule.Locator` for an example of how this protocol can be implemented.

### Locator

Locators are the mediators between storages and uploads. They represent where an uploaded file was stored so it can be retrieved. They contain a unique id, the name of the storage to which the file was uploaded, and a map of user defined metadata.

Locator also implements the upload protocol, which means moving a file from one storage to another is straightforward, and very useful for "promoting" a file from temporary (e.g. Disk) to permanent (e.g. S3) storage<sup>2</sup>:

```
old_file_data = %Locator{id: "/path/to/file.jpg", storage: Disk, metadata: %{}}
{:ok, new_id} = S3.put(old_file_data)`
```

Note: always remember to take care of cleaning up the old file as Capsule *never* automatically removes files:

`Disk.delete(old_file_data.id)`

<sup>2</sup> *As of version 0.6 Capsule all built-in storages and upload protocols except for Locator have been moved to [elixir-capsule/supplement](https://github.com/elixir-capsule/supplement).*

### Uploader

This helper was added in order to support DRYing up storage access. In most apps, there are certain types of assets that will be uploaded and handled in a similar, if not the same way, if only when it comes to where they are stored. You can `use` the uploader to codify the handling for specific types of assets.

```
defmodule AvatarUploader do
  use Capsule.Uploader, storages: [cache: Disk, store: S3]

  def build_options(upload, :cache, opts) do
    Keyword.put(opts, :prefix, "cache/#{Date.utc_today()}")
  end

  def build_options(upload, :store, opts) do
    opts
    |> Keyword.put(:prefix, "users/#{opts[:user_id]}/avatar")
    |> Keyword.drop([:user_id])
  end

  def build_metadata(upload, :store, _), do: [uploaded_at: DateTime.utc_now()]
end
```

Then you can get the files where they need to be without constructing all the options everywhere they might be uploaded: `AvatarUploader.store(upload, :store, user_id: 1)`

Note: as this example demonstrates, the function can receive arbitrary data and use it to customize how it builds the storage options before they are passed on.

## Integrations

Capsule's module design is intended to make it easy to implement your own custom utilities for handling files in the way you need. However, anticipating the most common use cases, it can be augmented with the following add-ons.

### [CapsuleEcto](https://github.com/elixir-capsule/capsule_ecto)

Provides the `Capsule.Ecto.Type` for Ecto schema fields which handles persisting Locator data in your repository.

### [CapsuleSupplement](https://github.com/elixir-capsule/supplement)

Contains a collection of some common file storages (including S3/Digital Ocean) and uploads (including `Plug.Upload`).

That's it! Happy uploading.
