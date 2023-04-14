defmodule ExOpenAi.URLGenerator do
  @moduledoc """
  Generates the URL for the API request.
  """

  @doc """
  Infers the URL for the API request based on the module name.
  """
  @spec infer_url(module) :: String.t()
  def infer_url(module) do
    case Module.split(module) do
      ["ExOpenAi", "Completion"] -> "https://api.openai.com/v1/completions"
      ["ExOpenAi", "NewImage"] -> "https://api.openai.com/v1/images/generations"
      ["ExOpenAi", "Chat"] -> "https://api.openai.com/v1/chat/completions"
      ["ExOpenAi", "Edit"] -> "https://api.openai.com/v1/edits"
      ["ExOpenAi", "Embedding"] -> "https://api.openai.com/v1/embeddings"
      ["ExOpenAi", "Whisper"] -> "https://api.openai.com/v1/audio/transcriptions"
      ["ExOpenAi", "Translation"] -> "https://api.openai.com/v1/audio/translations"
      _ -> "https://api.openai.com/v1"
    end
  end
end
