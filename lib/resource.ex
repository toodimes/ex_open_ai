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
      end

      if :create_stream in import_functions do
        @spec create_stream(Api.data(), list) :: Parser.parsed_response()
        def create_stream(data, options \\ []), do: Api.create_stream(__MODULE__, data, options)
      end

      if :create_with_file in import_functions do
        @spec create_with_file(Api.data(), atom(), list) :: Parser.parsed_response()
        def create_with_file(data, file_key, options \\ []), do: Api.create_with_file(__MODULE__, data, options)
      end

      if :list in import_functions do
        @spec list(list) :: Parser.parsed_response()
        def list(options \\ []), do: Api.list(__MODULE__, options)
      end

      if :retrieve in import_functions do
        @spec retrieve(String.t(), list) :: Parser.parsed_response()
        def retrieve(id, options \\ []), do: Api.retrieve(__MODULE__, id, options)
      end

      if :remove in import_functions do
        @spec remove(String.t(), list) :: Parser.parsed_response()
        def remove(id, options \\ []), do: Api.remove(__MODULE__, id, options)
      end

      defoverridable Module.definitions_in(__MODULE__, :def)
    end
  end
end
