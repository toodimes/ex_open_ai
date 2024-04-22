defmodule ExOpenAi.DeleteResponse do
  @type t :: %__MODULE__{
    id: Strint.t(),
    object: String.t(),
    deleted: boolean()
  }

  defstruct id: nil, object: nil, deleted: nil
end
