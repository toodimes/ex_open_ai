defmodule ExOpenAi.EmbeddingRequest do
  @moduledoc """
  Represents an embedding request to the OpenAI API.

  - [OpenAI API Docs](https://platform.openai.com/docs/api-reference/embeddings)
  """

  use ExOpenAi.Request

  alias ExOpenAi.Embedding

  @required_fields ~w(
    model
    input
  )a

  @optional_fields ~w(
    user
  )a

  @doc """
  Builds the create embedding request and validates the required fields.
  """
  @spec create(params :: map) :: {:ok, Embedding.t()} | {:error, map}
  def create(params) do
    params
    |> prepare(@optional_fields, @required_fields)
    |> Embedding.create()
  end
end
