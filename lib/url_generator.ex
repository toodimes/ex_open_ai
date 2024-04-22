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
      # Completions is being deprecated.
      ["ExOpenAi", "Completion"] -> "https://api.openai.com/v1/completions"
      ["ExOpenAi", "Images", "Image"] -> "https://api.openai.com/v1/images/generations"
      ["ExOpenAi", "Images", "Edit"] -> "https://api.openai.com/v1/images/edits"
      ["ExOpenAi", "Images", "Variation"] -> "https://api.openai.com/v1/images/variations"
      ["ExOpenAi", "Chat"] -> "https://api.openai.com/v1/chat/completions"
      ["ExOpenAi", "Edit"] -> "https://api.openai.com/v1/edits"
      ["ExOpenAi", "Embedding"] -> "https://api.openai.com/v1/embeddings"
      ["ExOpenAi", "Audio", "Speech"] -> "https://api.openai.com/v1/audio/speech"
      ["ExOpenAi", "Audio", "Translation"] -> "https://api.openai.com/v1/audio/translations"
      ["ExOpenAi", "Audio", "Transcription"] -> "https://api.openai.com/v1/audio/transcriptions"
      ["ExOpenAi", "FineTuningJob"] -> "https://api.openai.com/v1/fine_tuning/jobs"
      ["ExOpenAi", "Files", "File"] -> "https://api.openai.com/v1/files"
      ["ExOpenAi", "Model"] -> "https://api.openai.com/v1/models"
      ["ExOpenAi", "Moderation"] -> "https://api.openai.com/v1/moderations"

      # "As of the time of V1 release the below endpoints are considered in Beta"
      ["ExOpenAi", "Assistants", "Assistant"] -> "https://api.openai.com/v1/assistants"
      ["ExOpenAi", "Thread"] -> "https://api.openai.com/v1/threads"
      ["ExOpenAi", "Message"] -> "https://api.openai.com/v1/threads"
      ["ExOpenAi", "Run"] -> "https://api.openai.com/v1/threads"
      _ -> "https://api.openai.com/v1"
    end
  end
end
