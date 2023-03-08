ExUnit.start()

defmodule TestHelper do
  use ExUnit.Case, async: false
  alias ExOpenAi.Api
  import Mock

  def with_fixture(:post!, response, fun),
    do: with_fixture({:post!, fn _url, _options, _headers -> response end}, fun)

  def with_fixture(stub, fun) do
    with_mock Api, [:passthrough], [stub] do
      fun.()
    end
  end

  def json_response(map, status) do
    %{body: Jason.encode!(map), status_code: status}
  end
end
