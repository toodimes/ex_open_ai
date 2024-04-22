defmodule ExOpenAi.Audio.Translation do
  @moduledoc """
  Represents a translation request to the OpenAI API.

  - [OpenAI API Docs](https://platform.openai.com/docs/api-reference/audio/createTranslation)

  ## Examples
      iex> params = %{
      ...>   model: "whisper-1",
      ...>   file: "path/to/some_file.mp3",
      ...>   prompt: "translate this to french"
      ...> }
      iex> ExOpenAi.Audio.Translation.create(params)
      {:ok, %ExOpenAi.Audio.Translation{...}}
  """

  @type t :: %__MODULE__{
          text: String.t()
        }

  defstruct text: nil

  use ExOpenAi.Resource, import: [:new, :create_with_file]

  def create(params), do: create_with_file(params, :file)

  def keep_it_simple(response, _), do: response
end
