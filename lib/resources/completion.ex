defmodule ExOpenAi.Completion do
  @moduledoc """
  Represents a completion request to the OpenAI API.

  - [OpenAI API Docs](https://platform.openai.com/docs/api-reference/completions)

  ## Examples
      iex> params = %{
      ...>   model: "text-model",
      ...>   prompt: "tell me a joke",
      ...>   max_tokens: 500
      ...> }
      iex> ExOpenAi.Completion.create(params)
      {:ok, %ExOpenAi.Completion{...}}

      iex> ExOpenAi.Completion.create(%{})
      {:error, %{}}
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

  use ExOpenAi.Resource, import: [:new, :create, :create_stream]

  def keep_it_simple(response, true) do
    response
    |> Map.get(:choices)
    |> Enum.map(fn choice -> choice.text end)
  end

  def keep_it_simple(response, _), do: response
end
