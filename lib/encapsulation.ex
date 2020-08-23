defmodule Capsule.Encapsulation do
  defstruct [:id, :storage, :size, metadata: %{}]

  @type t() :: %__MODULE__{
          id: String.t(),
          storage: String.t(),
          size: integer(),
          metadata: map()
        }
end
