defmodule ExOpenAi.NewImageRequest do
  @moduledoc """
  Represents a new image request to the OpenAI API.

  - [OpenAI API Docs](https://platform.openai.com/docs/api-reference/images)
  """

  use ExOpenAi.Request

  alias ExOpenAi.NewImage

  @required_fields ~w(
    prompt
  )a

  @optional_fields ~w(
    n
    size
    response_format
    user
  )a

  @doc """
  Builds the create new image request and validates the required fields.
  """
  @spec create(params :: map) :: {:ok, NewImage.t()} | {:error, map}
  def create(params) do
    params
    |> prepare(@optional_fields, @required_fields)
    |> NewImage.create()
  end
end
