defmodule ExOpenAi.ChatRequest do
  @moduledoc """
  Represents a chat request to the OpenAI API.
  """

  use ExOpenAi.Request

  alias ExOpenAi.Chat

  @required_fields ~w(
    model
    messages
  )a

  @optional_fields ~w(
    temperature
    max_tokens
    n
    top_p
    stream
    stop
    presence_penalty
    frequency_penalty
    logit_bias
    user
  )a

  @doc """
  Builds the chat messages by appending to the list of messages in the map.
  """
  @spec do_append(params :: map, message :: map) :: map
  def do_append(params, message) do
    messages =
      params
      |> Map.get(:messages)
      |> Enum.concat([message])

    do_change(params, messages: messages)
  end

  @doc """
  Builds the create chat request and validates the required fields.
  """
  @spec create(params :: map) :: {:ok, Chat.t()} | {:error, map}
  def create(params) do
    params
    |> prepare(@optional_fields, @required_fields)
    |> Chat.create()
  end
end
