defmodule ExOpenAi.Whisper do
  @moduledoc """

  """

  @type t :: %__MODULE__{
          text: String.t()
        }

  defstruct text: nil

  use ExOpenAi.Resource, import: [:new, :create_file]

  def keep_it_simple(response, _), do: response
end
