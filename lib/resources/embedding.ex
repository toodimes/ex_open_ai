defmodule ExOpenAi.Embedding do
  @moduledoc """
  Represents an embedding request to the OpenAI API.

  - [OpenAI API Docs](https://platform.openai.com/docs/api-reference/embeddings)
  """

  defstruct object: nil,
            model: nil,
            data: nil,
            usage: nil

  use ExOpenAi.Resource, import: [:new, :create]

  def keep_it_simple(response, true) do
    response
    |> Map.get(:data)
    |> Enum.map(fn data -> data.embedding end)
  end

  def keep_it_simple(response, _), do: response
end
