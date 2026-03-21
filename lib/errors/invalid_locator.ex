defmodule Capsule.Errors.InvalidLocator do
  @moduledoc "Raised when a locator cannot be created from the given attributes."
  defexception message: "locator is invalid"
end
