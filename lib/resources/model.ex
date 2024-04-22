defmodule ExOpenAi.Model do
  @moduledoc """
  Represents a model request to the OpenAI API.

  - [OpenAI API Docs](https://platform.openai.com/docs/api-reference/models)

  ## Examples
  """

  @type t :: %__MODULE__{
          object: String.t(),
          id: String.t(),
          owned_by: String.t(),
          permission: list()
        }

  defstruct object: nil,
            id: nil,
            owned_by: nil,
            permission: nil

  use ExOpenAi.Resource, import: [:list, :retrieve, :remove]

  def keep_it_simple(response, _), do: response
end
