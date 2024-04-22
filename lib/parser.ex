defmodule ExOpenAi.Parser do
  @moduledoc """
  Parses the response from the OpenAI API.
  """

  alias ExOpenAi.DeleteResponse

  @type metadata :: map
  @type http_status_code :: number
  @type key :: String.t()
  @type success :: {:ok, map}
  @type success_delete :: :ok
  @type error :: {:error, map, http_status_code} | {:error, :atom}

  @type parsed_response :: success | error

  @doc """
  Parse a response expected to contain a resource. If you pass in a
  module as the first argument, the JSON will be parsed into that module's
  `__struct__`.

  ## Examples
  Given you have a module named `Resource`, defined like this:
      defmodule Resource do
        defstruct sid: nil
      end

  You can parse JSON into that module's struct like so:
      iex> response = %{body: "{ \\"id\\": \\"cmpl-uqkvlQyYK7bGYrRHQ0eXlWi7\\" }", status_code: 200}
      ...> ExOpenAi.Parser.parse(response, Resource, nil)
      {:ok, %Resource{id: "cmpl-uqkvlQyYK7bGYrRHQ0eXlWi7"}}

  You can also parse into a regular map if you want.
      iex> response = %{body: "{ \\"id\\": \\"cmpl-uqkvlQyYK7bGYrRHQ0eXlWi7\\" }", status_code: 200}
      ...> ExOpenAi.Parser.parse(response, %{}, nil)
      {:ok, %{"id" => "cmpl-uqkvlQyYK7bGYrRHQ0eXlWi7"}}
  """
  @spec parse({:ok, Tesla.Env.t()} | String.t(), module, boolean() | nil) :: success | error
  def parse(response, map, _simple)
      when is_map(map) and not :erlang.is_map_key(:__struct__, map) do
    handle_errors(response, fn body -> Jason.decode!(body) end)
  end

  def parse(response, module, simple) when is_binary(response) do
    handle_errors(response, fn body ->
      struct(module, Jason.decode!(body, keys: :atoms))
      |> module.keep_it_simple(simple)
    end)
  end

  def parse(response, ExOpenAi.Audio.Speech, _simple) do
    handle_errors(response, fn body ->
      %ExOpenAi.Audio.Speech{output: body}
    end)
  end

  def parse(response, module, simple) do
    handle_errors(response, fn body ->
      struct(module, Jason.decode!(body, keys: :atoms))
      |> module.keep_it_simple(simple)
    end)
  end

  @doc """
  Parse a list of resources.
  """
  @spec parse_list({:ok, Tesla.Env.t()} | String.t(), module, boolean() | nil) :: success | error
  def parse_list(response, module, simple) do
    handle_errors(response, fn body ->
      body
      |> Jason.decode!(keys: :atoms)
      |> case do
        %{object: "list", data: data} ->
          data
          |> Enum.map(fn item ->
            struct(module, item)
            |> module.keep_it_simple(simple)
          end)

        _ ->
          []
      end
    end)
  end

  @doc """
  Parse a deletion request.
  """
  @spec parse_delete({:ok, Tesla.Env.t()} | String.t()) :: success_delete | error
  def parse_delete(response) do
    handle_errors(response, fn body ->
      struct(DeleteResponse, Jason.decode!(body, keys: :atoms))
    end)
  end

  defp handle_errors(response, fun) when is_binary(response), do: {:ok, fun.(response)}

  defp handle_errors({:error, error}, _fun) do
    {:error, error}
  end

  defp handle_errors(response, fun) do
    case response do
      %{body: body, status: status} when status in [200, 201] ->
        {:ok, fun.(body)}

      %{body: _, status: status} when status in [202, 204] ->
        :ok

      %{body: body, status: status} ->
        {:error, Jason.decode!(body), status}
    end
  end
end
