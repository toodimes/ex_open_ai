defmodule ExOpenAi.ChatRequest do
  @moduledoc """
  Represents a chat request to the OpenAI API.

  - [OpenAI API Docs](https://platform.openai.com/docs/api-reference/chat/create)

  This module allows you to add a message to the list of messages in the request as well as validate any request to the Chat resource.

  ## Examples
      iex> params = %{
      ...>   model: "text-model",
      ...>   messages: [
      ...>     %{content: "hello"}
      ...>   ]
      ...> }
      iex> ExOpenAi.ChatRequest.create(params)
      {:ok, %ExOpenAi.Chat{...}}

      iex> ExOpenAi.ChatRequest.do_append(params, %{content: "world"})
      %{model: "text-model", messages: [%{content: "hello"}, %{content: "world"}]}
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

  ## Examples

      iex> params = %{
      ...>   model: "text-model",
      ...>   messages: [
      ...>     %{role: "system", content: "hello"}
      ...>   ]
      ...> }
      iex> ExOpenAi.ChatRequest.do_append(params, %{role: "user", content: "world"})
      %{model: "text-model", messages: [%{content: "hello"}, %{content: "world"}]}
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

  ## Examples

      iex> params = %{
      ...>   model: "text-model",
      ...>   messages: [
      ...>     %{role: "system", content: "hello"}
      ...>   ]
      ...> }
      iex> ExOpenAi.ChatRequest.create(params)
      {:ok, %ExOpenAi.Chat{...}}
  """
  @spec create(params :: map) :: {:ok, Chat.t()} | {:error, map}
  def create(params) do
    params
    |> prepare(@optional_fields, @required_fields)
    |> Chat.create()
  end
end
