defmodule ExOpenAi.Api do
  @moduledoc """
  The main module for the ExOpenAi API client.

  Provides a wrapper around Httpoison for making requests to the OpenAI API.
  """

  use HTTPoison.Base

  alias ExOpenAi.Config
  alias ExOpenAi.Parser
  alias ExOpenAi.URLGenerator, as: URL
  alias __MODULE__

  # Image generation can take some time, so we need to increase the timeout
  @default_timeout 25_000

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

    module
    |> URL.infer_url()
    |> Api.post!(data, options, recv_timeout: @default_timeout)
    |> Parser.parse(module, options[:simple])
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
  @spec auth_header(header :: list, options :: list) :: list
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
    |> Jason.encode!()
  end

  def format_data(data) when is_map(data), do: Jason.encode!(data)

  ###
  # HTTPoison API
  ###
  def process_request_headers(headers \\ []) do
    headers
    |> Keyword.put(:"Content-Type", "application/json")
    |> auth_header({Config.api_key(), Config.organization()})
  end
end
