defmodule ExOpenAi.Completion do
  @moduledoc """
  Represents a completion request to the OpenAI API.

  - [OpenAI API Docs](https://platform.openai.com/docs/api-reference/completions)

  ## Examples
  TODO: EXAMPLES

  TODO: ENFORCE REQUIRED FIELDS
  """
  defstruct id: nil,
            object: nil,
            created: nil,
            model: nil,
            choices: nil,
            usage: nil

  @type t :: %__MODULE__{
          id: String.t(),
          object: String.t(),
          created: integer(),
          model: String.t(),
          choices: list(),
          usage: map()
        }

  use ExOpenAi.Resource, import: [:new, :create]

  def keep_it_simple(response, true) do
    response
    |> Map.get(:choices)
    |> Enum.map(fn choice -> choice.text end)
  end

  def keep_it_simple(response, _), do: response
end
