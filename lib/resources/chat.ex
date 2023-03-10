defmodule ExOpenAi.Chat do
  @moduledoc """
  Represents a chat request to the OpenAI API.

  - [OpenAI API Docs](https://platform.openai.com/docs/api-reference/chat/create)

  ## Examples
      iex> params = %{
      ...>   model: "text-model",
      ...>   messages: [
      ...>     %{content: "hello"}
      ...>   ]
      ...> }
      iex> ExOpenAi.Chat.create(params)
      {:ok, %ExOpenAi.Chat{...}}

      iex> ExOpenAi.Chat.create(%{})
      {:error, %{}}
  """

  @type t :: %__MODULE__{
        id: String.t(),
        object: String.t(),
        created: integer(),
        choices: list(),
        usage: map()
      }

  defstruct id: nil,
            object: nil,
            created: nil,
            choices: nil,
            usage: nil

  use ExOpenAi.Resource, import: [:new, :create]

  @spec keep_it_simple(map, boolean()) :: list() | map()
  def keep_it_simple(response, true) do
    response
    |> Map.get(:choices)
    |> Enum.sort_by(fn choice -> choice.index end)
    |> Enum.map(fn choice -> choice.text end)
  end

  def keep_it_simple(response, _), do: response
end
