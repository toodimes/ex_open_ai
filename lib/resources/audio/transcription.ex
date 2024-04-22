defmodule ExOpenAi.Audio.Transcription do
  @moduledoc """
  Represents a transcription request to the OpenAI API.

  - [OpenAI API Docs](https://platform.openai.com/docs/api-reference/audio/createTranscription)

  ## Notes
    The file must be a local file path, as URLs are not currently supported.
    If you need to transcribe audio from a URL, you will need to implement that functionality yourself.

    On large bodies of text it can really take a while to process.
    Its recommended to stream to a process to save or play the file.




  ## Examples
      iex> params = %{
      ...>   model: "whisper-1",
      ...>   file: "path/to/some_file.mp3"
      ...> }
      iex> ExOpenAi.Audio.Transcription.create(params)
      {:ok, %ExOpenAi.Audio.Transcription{...}}

      iex> ExOpenAi.Audio.Transcription.create(%{})
      {:error, %{}}
  """

  @type t :: %__MODULE__{
          text: String.t(),
          language: String.t(),
          duration: float(),
          text: String.t(),
          segments: list(),
          words: list()
  }

  defstruct text: nil,
            language: nil,
            duration: nil,
            segments: nil,
            words: nil

  use ExOpenAi.Resource, import: [:new, :create_with_file]

  def create(params), do: create_with_file(params, :file)

  def keep_it_simple(response, _), do: response
end
