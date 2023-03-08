defmodule ExOpenAi.ApiTest do
  use ExUnit.Case, async: false

  import TestHelper

  alias ExOpenAi.Api

  defmodule Resource do
    defstruct choices: nil,
              model: nil,
              object: nil,
              created: nil
    def resource_name, do: "Resources"
    def keep_it_simple(response, true), do: List.first(response.choices)
    def keep_it_simple(response, _), do: response
  end

  doctest ExOpenAi.Api

  test ".create should return the resource if successful" do
    json = json_response(%{choices: ["Hello, World!"], model: "davinci", object: "completion", created: 1620000000}, 200)

    with_fixture(:post!, json, fn ->
      assert {:ok, %Resource{choices: ["Hello, World!"], model: "davinci", object: "completion", created: 1620000000}} ==
        Api.create(Resource, %{prompt: "value"})
    end)
  end

  test ".create should return an error from OpenAI if the resource could not be created" do
    json = json_response(%{message: "Resource couldn't be created."}, 500)

    with_fixture(:post!, json, fn ->
      assert {:error, %{"message" => "Resource couldn't be created."}, 500} ==
        Api.create(Resource, %{prompt: "value"})
    end)
  end

  ###
  # API Tests
  ###
  test ".process_request_headers adds the correct headers" do
    Application.put_env(:ex_open_ai, :api_key, "test_key")
    headers = Api.process_request_headers([])
    content_type = {:"Content-Type", "application/json"}

    assert content_type in headers
    assert {"Authorization", "Bearer test_key"} in headers
  after
    Application.delete_env(:ex_open_ai, :api_key)
  end

  test ".format_data converts the map to json" do
    data = %{prompt: "Hello, World!"}
    json = Jason.encode!(data)

    assert json == Api.format_data(data)
  end

  test ".format_data converts the list to json" do
    map_data = %{prompt: "Hello, World!"}
    data = [prompt: "Hello, World!"]
    json = Jason.encode!(map_data)

    assert json == Api.format_data(data)
  end
end
