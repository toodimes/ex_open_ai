defmodule ExOpenAi.Files.File do
  @moduledoc """
  Represents a file request to the OpenAI API.

  - [OpenAI API Docs](https://platform.openai.com/docs/api-reference/files)

  ## Examples
      iex> params = %{
      ...>   purpose: "search",
      ...>   file: "file-uuid"
      ...> }
      iex> ExOpenAi.Files.File.create(params)
      {:ok, %ExOpenAi.Files.File{...}}

      iex> ExOpenAi.Files.File.retrieve(%{})
      {:error, %{}}
  """

  @type t :: %__MODULE__{
          id: String.t(),
          object: String.t(),
          bytes: integer(),
          created_at: integer(),
          filename: String.t(),
          purpose: String.t()
        }

  defstruct id: nil,
            object: nil,
            bytes: nil,
            created_at: nil,
            filename: nil,
            purpose: nil

  use ExOpenAi.Resource, import: [:list, :retrieve, :remove, :create_with_file]

  def create(params), do: create_with_file(params, :file)

  def keep_it_simple(response, _), do: response
end
