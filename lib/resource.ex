defmodule ExOpenAi.Resource do
  @moduledoc """
  The base module for all resources in the ExOpenAi API client.
  """

  @doc false
  defmacro __using__(options) do
    import_functions = options[:import] || []

    quote bind_quoted: [import_functions: import_functions] do
      alias ExOpenAi.Api
      alias ExOpenAi.Parser

      @spec new :: %__MODULE__{}
      def new, do: %__MODULE__{}

      @spec new(attributes :: list) :: %__MODULE__{}
      def new(attributes) do
        do_new(%__MODULE__{}, attributes)
      end

      @spec do_new(%__MODULE__{}, attributes :: list) :: %__MODULE__{}
      def do_new(struct, []), do: struct

      def do_new(struct, [{key, val} | tail]) do
        do_new(Map.put(struct, key, val), tail)
      end

      if :create in import_functions do
        @spec create(Api.data(), list) :: Parser.parsed_response()
        def create(data, options \\ []), do: Api.create(__MODULE__, data, options)

        @spec required_fields :: list
        def required_fields, do: __MODULE__.required_fields()
      end

      defoverridable Module.definitions_in(__MODULE__, :def)
    end
  end
end
