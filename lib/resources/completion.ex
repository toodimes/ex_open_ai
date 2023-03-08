defmodule ExOpenAi.Completion do
  @moduledoc """
  Represents a completion request to the OpenAI API.

  - [OpenAI API Docs](https://beta.openai.com/docs/api-reference/completions)

  ## Examples
  TODO: EXAMPLES
  """

  # This is for responses from the API

  defstruct id: nil,
            object: nil,
            created: nil,
            model: nil,
            choices: nil,
            usage: nil

  use ExOpenAi.Resource, import: [:new, :create]

  def keep_it_simple(response, true) do
    response
    |> IO.inspect(label: " #{List.last(String.split(__ENV__.file, "/"))}:#{__ENV__.line} ")
    |> Map.get(:choices)
    |> Enum.map(fn choice -> choice.text end)
  end

  def keep_it_simple(response, _), do: response
end
