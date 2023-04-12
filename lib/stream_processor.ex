defmodule ExOpenAi.StreamProcessor do
  @moduledoc """
  `ExOpenAi.StreamProcessor` is a module that handles streaming HTTP responses for the ExOpenAi library.

  It provides functions to process and parse chunks of data as they are received from the HTTP stream. It works with the `ExOpenAi.Parser` module to parse and decode the received data.

  ## Functions

    * `close_async_response/1`: Closes the async response by stopping the hackney process.
    * `handle_async_response/2`: Handles different types of async responses, such as status, headers, chunks, and end of the stream.
    * `parse_chunk/3`: A private function that splits the received chunk, trims it, and decodes it using the provided module.
    * `decode_chunk/2`: A private function that decodes the chunk based on its content. If the chunk is "[DONE]", it returns `{:done, ""}`, otherwise, it calls the Parser to parse the chunk.

  ## Usage

  The primary use case for this module is to handle streaming HTTP responses from the OpenAI API in a smooth and efficient manner.
  By working with the `ExOpenAi.Parser` module, it allows the ExOpenAi library to process the data as it is received, rather than waiting for the entire response.
  """

  alias ExOpenAi.Parser

  def close_async_response(resp) do
    :hackney.stop_async(resp)
  end

  def handle_async_response({:done, resp}, _module) do
    {:halt, resp}
  end

  def handle_async_response(%HTTPoison.AsyncResponse{id: id} = resp, module) do
    receive do
      %HTTPoison.AsyncStatus{id: ^id, code: _code} ->
        HTTPoison.stream_next(resp)
        {[], resp}

      %HTTPoison.AsyncHeaders{id: ^id, headers: _headers} ->
        HTTPoison.stream_next(resp)
        {[], resp}

      %HTTPoison.AsyncChunk{id: ^id, chunk: chunk} ->
        HTTPoison.stream_next(resp)
        parse_chunk(chunk, resp, module)

      %HTTPoison.AsyncEnd{id: ^id} ->
        {:halt, resp}
    end
  end

  defp parse_chunk("{\n    \"error\":" <> _rest = res, resp, _module) do
    {[{:error, Jason.decode!(res), 400}], resp}
  end

  defp parse_chunk("data: [DONE]" <> _rest, resp, _module) do
    {[{:done, ""}], resp}
  end

  defp parse_chunk(chunk, resp, module) do
    chunk = chunk
    |> String.split("data:")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(& decode_chunk(&1, module))

    {chunk, resp}
  end

  defp decode_chunk("[DONE]", _module) do
    {:done, ""}
  end

  defp decode_chunk(chunk, module) do
    Parser.parse(chunk, module, false)
  end
end
