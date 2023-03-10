defmodule ExOpenAi.CompletionRequest do
  @moduledoc """
  Represents a completion request to the OpenAI API.

  - [OpenAI API Docs](https://platform.openai.com/docs/api-reference/completions)
  """

  use ExOpenAi.Request

  alias ExOpenAi.Completion

  @required_fields ~w(
    model
  )a

  @optional_fields ~w(
    prompt
    suffix
    max_tokens
    temperature
    top_p
    n
    stream
    logprobs
    echo
    stop
    presence_penalty
    frequency_penalty
    best_of
    logit_bias
    user
  )a

  @doc """
  Builds the create completion request and validates the required fields.
  """
  @spec create(params :: map) :: {:ok, ExOpenAi.Completion.t()} | {:error, map}
  def create(params) do
    params
    |> prepare(@optional_fields, @required_fields)
    |> Completion.create()
  end
end
