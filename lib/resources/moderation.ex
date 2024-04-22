defmodule ExOpenAi.Moderation do
  @moduledoc """
  Represents a moderation request to the OpenAI API.

  - [OpenAI API Docs](https://platform.openai.com/docs/api-reference/moderations)

  ## Examples

      iex> params = %{
      ...>   input: "I want to kill them all",
      ;..>   model: "text-moderation-latest"
      ...> }
      iex> ExOpenAi.Moderation.create(params)
      {:ok, %ExOpenAi.Moderation{...}}
  """

  @type t :: %__MODULE__{
          id: String.t(),
          model: String.t(),
          results: list()
        }

  defstruct id: nil,
            model: nil,
            results: nil

  use ExOpenAi.Resource, import: [:new, :create]

  def keep_it_simple(response, _), do: response
end
