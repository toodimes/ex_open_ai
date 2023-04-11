defmodule ExOpenAi.Edit do
  @moduledoc """
  Represents an edit request to the OpenAI API.

  - [OpenAI API Docs](https://platform.openai.com/docs/api-reference/edits)

  ## Examples
  """
  @type t :: %__MODULE__{
          object: String.t(),
          created: integer(),
          choices: list(),
          usage: map()
        }

  defstruct object: nil,
            created: nil,
            choices: nil,
            usage: nil

  use ExOpenAi.Resource, import: [:new, :create]

  def keep_it_simple(response, true) do
    response
    |> Map.get(:choices)
    |> Enum.map(fn choice -> choice.text end)
  end

  def keep_it_simple(response, _), do: response
end
