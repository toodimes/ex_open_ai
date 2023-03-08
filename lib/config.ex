defmodule ExOpenAi.Config do
  @moduledoc """
  Stores the configuration for the ExOpenAi client.

  All settings also accept `{:system, "ENV_VAR_NAME"}` to read their
  values from environment variables at runtime
  """

  @doc """
  Returns the api_key, set it in `mix.exs`

    config :ex_open_ai, api_key: "API_KEY"
  """
  def api_key, do: from_env(:ex_open_ai, :api_key)

  @doc """
  Returns the organization, set it in `mix.exs`

    config :ex_open_ai, organization: "ORGANIZATION"
  """
  def organization, do: from_env(:ex_open_ai, :organization)


  @doc """
  A wrapper around `Application.get_env/2`, providing automatic support for `{:system, "VARIABLE"}`.
  """
  def from_env(app, key, default \\ nil)

  def from_env(app, key, default) do
    app
    |> Application.get_env(key, default)
    |> read_from_system(default)
  end

  defp read_from_system({:system, env}, default), do: System.get_env(env) || default
  defp read_from_system(value, _default), do: value
end
