defmodule ExOpenAi.Request do
  @moduledoc """
  The base module for all requests in the ExOpenAi API client.

  Can be used to prepare, validate and update requests.

  ## Examples
      iex> params = %{
      ...>   model: "text-model",
      ...>   messages: [
      ...>     %{content: "hello"}
      ...>   ]
      ...> }
      iex> Request.do_change(params, promp: "this is a prompt")
      %{model: "text-model", messages: [%{content: "hello"}], prompt: "this is a prompt"}
  """

  @doc false
  defmacro __using__(_options) do
    quote do
      @doc """
      Builds the map by adding to the existing map and updates the map with the attributes passed in.

      ## Examples

          iex> params = %{
          ...>   model: "text-model",
          ...>   messages: [
          ...>     %{content: "hello"}
          ...>   ]
          ...> }
          iex> Request.do_change(params, promp: "this is a prompt")
          %{model: "text-model", messages: [%{content: "hello"}], prompt: "this is a prompt"}
      """
      @spec do_change(map, attributes :: list) :: map
      def do_change(map, attributes) do
        incoming_map =
          attributes
          |> Enum.into(%{})

        Map.merge(map, incoming_map)
      end

      @doc """
      Ensures that the map has the required fields.

      ## Examples

            iex> params = %{model: "text-model", messages: [%{content: "hello"}]}
            iex> Request.has_required_fields?(params, [:model, :messages])
            true

            iex> params = %{model: "text-model"}
            iex> Request.has_required_fields?(params, [:model, :messages])
            false
      """
      @spec has_required_fields?(map, fields :: list) :: boolean
      def has_required_fields?(map, fields) do
        keys =
          map
          |> Map.keys()

        Enum.all?(fields, fn field -> field in keys end)
      end

      @doc """
      Prepares the map by removing any fields that are not in the list of fields. and ensures required fields are present.

      ## Examples

            iex> params = %{
            ...>   model: "text-model",
            ...>   messages: [
            ...>     %{content: "hello"}
            ...>   ]
            ...> }
            iex> Request.prepare(params, [], [:model, :messages])
            %{model: "text-model", messages: [%{content: "hello"}]}

            iex> params = %{
            ...>   model: "text-model",
            ...>   messages: [
            ...>     %{content: "hello"}
            ...>   ]
            ...> }
            iex> Request.prepare(params, [], [:model, :messages, :prompt])
            ** (RuntimeError) Required fields are missing
      """
      @spec prepare(map, fields :: list, required_fields :: list) :: map
      def prepare(map, fields, required_fields) do
        if has_required_fields?(map, required_fields) do
          map
          |> delete_invalid_fields(fields ++ required_fields)
        else
          raise "Required fields are missing"
        end
      end

      @doc """
      Deletes any fields that are not in the list of fields.

      ## Examples

            iex> params = %{
            ...>   model: "text-model",
            ...>   messages: [
            ...>     %{content: "hello"}
            ...>   ]
            ...> }
            iex> Request.delete_invalid_fields(params, [:model, :messages])
            %{model: "text-model", messages: [%{content: "hello"}]}
      """
      @spec delete_invalid_fields(map, fields :: list) :: map
      def delete_invalid_fields(map, fields) do
        map
        |> Enum.filter(fn {key, _value} -> key in fields end)
        |> Enum.into(%{})
      end
    end
  end
end
