defmodule ExOpenAi.NewImage do
  @moduledoc """
  Represents a new image request to the OpenAI API.

  - [OpenAI API Docs](https://platform.openai.com/docs/api-reference/images)

  ## Examples
  """

  defstruct data: nil,
            created: nil

  @type t :: %__MODULE__{
          data: list(),
          created: integer()
        }

  use ExOpenAi.Resource, import: [:new, :create]

  def keep_it_simple(response, true) do
    response
    |> Map.get(:data)
    |> Enum.map(fn data -> data.url end)
  end

  def keep_it_simple(response, _), do: response
end
