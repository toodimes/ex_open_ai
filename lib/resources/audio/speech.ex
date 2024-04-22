defmodule ExOpenAi.Audio.Speech do
  @moduledoc """
  Represents a TTS request to the OpenAI API.

  - [OpenAI API Docs](https://platform.openai.com/docs/api-reference/audio/createSpeech)

  ## Examples
      iex> params = %{
      ...>   model: "tts-1",
      ...>   input: "There was an old man named Michael Finnigan",
      ...>   response_format: "mp3", / default is mp3
      ...>   voice: "alloy"
      ...> }
      iex> ExOpenAi.Audio.Speech.create(params)
      {:ok, %ExOpenAi.Audio.Speech{...}}

      iex> ExOpenAi.Audio.Speech.create(%{})
      {:error, %{}}
  """
  @type t :: %__MODULE__{
          output: binary()
  }

  defstruct output: nil

  use ExOpenAi.Resource, import: [:new, :create]
end
