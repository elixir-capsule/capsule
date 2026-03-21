defmodule Capsule.Errors.InvalidStorage do
  @moduledoc "Raised when a storage module cannot be resolved from a locator."
  defexception message: "storage is invalid"
end
