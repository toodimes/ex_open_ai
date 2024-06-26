defmodule ExOpenAi.Api do
  @moduledoc """
  The main module for the ExOpenAi API client.

  Provides a wrapper around Httpoison for making requests to the OpenAI API.
  """

  # use HTTPoison.Base

  use Tesla

  alias Tesla.Multipart

  alias ExOpenAi.Config
  alias ExOpenAi.Parser
  alias ExOpenAi.URLGenerator, as: URL
  alias ExOpenAi.StreamProcessor

  @type data :: map | list

  @doc """
  Create a new resource in the OpenAI API with a POST request.
  ## Examples
      ExOpenAi.Api.create(ExOpenAi.Completion, [prompt: "tell me a joke", max_tokens: 500])
      {:ok, %Completion{ ... }}
      ExOpenAi.Api.create(ExOpenAi.Completion, [])
      {:error, %{"model" => "model is required"}, 400}
  """
  @spec create(atom, data :: list | map, list) :: Parser.success() | Parser.error()
  def create(module, data, options \\ []) do
    data = format_data(data)

    url = module
    |> URL.infer_url()

    client()
    |> post!(url, data, options)
    |> Parser.parse(module, options[:simple])
  end

  # %{messages: [%{role: "use", content: "what is 2 + 2?"}], model: "gpt-4-turbo"}
  @doc """
  Creates a stream using the provided module, data, and options.

  The stream is created using the `Stream.resource/3` function, where the initial function posts the data with `Api.post!/4`, the intermediate function processes the async response with `StreamProcessor.handle_async_response/2`, and the after function closes the async response with `StreamProcessor.close_async_response/1`.

  ## Parameters

    * `module` - The module to be used for handling the data stream.
    * `data` - A keyword list containing the data to be sent in the request.
    * `options` - An optional keyword list of additional options for the request.

  ## Returns

    * A stream that is created using the `Stream.resource/3` function, allowing processing of the data as it is received.

  ## Usage

  This function is used to create a stream with the specified module, process ID, data, and options. This enables efficient handling of streaming data from the OpenAI API.

  ## Note that this is the only function that uses HTTPoison, Tesla does not have good support for streaming.
  """
  @spec create_stream(atom, data :: list | map, list) :: any()
  def create_stream(module, data, options \\ []) do
    data =
      cond do
        is_list(data) ->
          data
          |> Keyword.put(:stream, true)

        is_map(data) ->
          data
          |> Map.put(:stream, true)
      end
      |> format_data()
      |> Jason.encode!()

    url =
      module
      |> URL.infer_url()

    Stream.resource(
      fn ->
        HTTPoison.post!(url, data, process_request_headers(options),
          stream_to: self(),
          async: :once,
          recv_timeout: Config.timeout()
        )
      end,
      &StreamProcessor.handle_async_response(&1, module),
      &StreamProcessor.close_async_response/1
    )
  end

  @doc """
  Create with a file upload.

  Thing to note:
  - The `file` parameter is required
  - Additional data that has a list of binaries in it is currently supported. But if the nature of the form shifts so that nested data within a value may not work.

  ## Examples
      ExOpenAi.Api.create_with_file(ExOpenAi.Completion, [prompt: "tell me a joke", max_tokens: 500])
      {:ok, %Completion{ ... }}
      ExOpenAi.Api.create_with_file(ExOpenAi.Completion, [])
      {:error, %{"model" => "model is required"}, 400}
  """
  @spec create_with_file(atom, data :: list | map, atom, list) :: Parser.success() | Parser.error()
  def create_with_file(module, data, file_key \\ :atom, options \\ [])

  def create_with_file(module, data, file_key, options) when is_list(data) do
    # path to file
    file = Keyword.get(data, file_key)

    mp = Multipart.new()
    |> Multipart.add_file(file, name: Atom.to_string(file_key))


    additional_data =
      data
      |> Keyword.delete(file_key)
      |> Enum.reduce(mp, fn
        {k, v}, acc when is_list(v) ->
          Enum.reduce(v, acc, fn v, acc -> Multipart.add_field(acc, "#{k}[]", v) end)
        {k, v}, acc ->
          acc
          |> Multipart.add_field(k, v)
      end)

    url = module
    |> URL.infer_url()

    client()
    |> post!(url, additional_data, options)
    |> Parser.parse(module, options[:simple])
  end

  def create_with_file(module, data, file_key, options) when is_map(data) do
    create_with_file(module, Map.to_list(data), file_key, options)
  end

  @doc """
  List all the resource in the OpenAI API.

  ## Examples

      ExOpenAi.Api.list(ExOpenAi.Completion)
      {:ok, [%Completion{ ... }]}
  """
  @spec list(atom, list) :: Parser.success() | Parser.error()
  def list(module, options \\ []) do
    url = module
    |> URL.infer_url()

    client()
    |> get!(url, options)
    |> Parser.parse_list(module, options[:simple])
  end

  @doc """
  Retrieve a resource from the OpenAI API.

  ## Examples
      ExOpenAi.Api.retrieve(ExOpenAi.Modle, "gpt-4-turbo")
      {:ok, %Completion{ ... }}
  """
  @spec retrieve(atom, String.t(), list) :: Parser.success() | Parser.error()
  def retrieve(module, id, options \\ []) do
    url = module
    |> URL.infer_url()

    client()
    |> get!(url <> "/" <> id, options)
    |> Parser.parse(module, options[:simple])
  end

  @doc """
  Delete a resource from the OpenAI API.

  ## Examples
      ExOpenAi.Api.delete(ExOpenAi.Modle, "gpt-4-turbo")
      {:ok, %Completion{ ... }}
  """
  @spec remove(atom, String.t(), list) :: Parser.success() | Parser.error()
  def remove(module, id, options \\ []) do
    url = module
    |> URL.infer_url()

    client()
    |> delete!(url <> "/" <> id, options)
    |> Parser.parse_delete()
  end

  @doc """
  Builds the authorization header for the request.
  """
  @spec auth_header(options :: list) :: list
  def auth_header(options \\ []) do
    auth_header([], {options[:api_key], options[:organization]})
  end

  @doc """
  Builds the actual authorization header for the request.

  ## Examples

    iex> ExOpenAi.Api.auth_header([], {"api123", "org345"})
    [{"Authorization", "Bearer api123"}, {"OpenAI-Organization", "org345"}]

    iex> ExOpenAi.Api.auth_header([], {"api123", nil})
    [{"Authorization", "Bearer api123"}]
  """
  @spec auth_header(header :: list, tuple()) :: list
  def auth_header(headers, {api_key, organzation}) do
    headers
    |> put_header("Authorization", "Bearer #{api_key}")
    |> put_header("OpenAI-Organization", organzation)
  end

  defp put_header(headers, _key, value) when is_nil(value), do: headers
  defp put_header(headers, key, value), do: headers ++ [{key, value}]

  @spec format_data(list | map) :: binary
  def format_data(data)

  def format_data(data) when is_list(data) do
    data
    |> Map.new()
  end

  def format_data(data) when is_map(data), do: data

  def ensure_valid_filename(filename) do
    URI.encode(filename)
  end

  ###
  # TESLA API
  ###
  def process_request_headers(headers \\ []) do
    headers
    |> Keyword.put(:"Content-Type", "application/json")
    |> auth_header({Config.api_key(), Config.organization()})
  end

  def client() do
    [
      {Tesla.Middleware.Timeout, timeout: Config.timeout()},
      {Tesla.Middleware.Headers, process_request_headers()},
      Tesla.Middleware.EncodeJson
    ]
    |> Tesla.client()
  end
end
