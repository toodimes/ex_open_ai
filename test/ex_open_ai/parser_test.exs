defmodule ExOpenAi.ParserTest do
  use ExUnit.Case
  import ExOpenAi.Parser

  defmodule Resource do
    defstruct choices: nil, object: nil, id: nil
    def keep_it_simple(response, true), do: List.first(response.choices)
    def keep_it_simple(response, _), do: response
  end

  doctest ExOpenAi.Parser

  test ".parse should decode a response into a struct" do
    response = %{
      body:
        "{ \"choices\": [\"Hello, World!\"], \"object\": \"completion\", \"id\": \"cmpl-123\" }",
      status_code: 200
    }

    assert {:ok, %Resource{choices: ["Hello, World!"], object: "completion", id: "cmpl-123"}} ==
             parse(response, Resource, nil)
  end

  test ".parse should return an error when response is 401" do
    response = %{body: "{ \"message\": \"Invalid Authentication\" }", status_code: 401}

    assert {:error, %{"message" => "Invalid Authentication"}, 401} ==
             parse(response, Resource, nil)
  end

  test ".parse should return an error when the rate limit is reached" do
    response = %{body: "{ \"message\": \"Rate limit exceeded\" }", status_code: 429}
    assert {:error, %{"message" => "Rate limit exceeded"}, 429} == parse(response, Resource, nil)
  end

  test ".parse should return an error when the server returns 500" do
    response = %{body: "{ \"message\": \"Internal Server Error\" }", status_code: 500}

    assert {:error, %{"message" => "Internal Server Error"}, 500} ==
             parse(response, Resource, nil)
  end
end
