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

  defmodule FileResource do
    defstruct text: nil

    def resource_name, do: "FileResources"
    def keep_it_simple(response, _), do: response
  end

  doctest ExOpenAi.Api

  test ".create should return the resource if successful" do
    json =
      json_response(
        %{
          choices: ["Hello, World!"],
          model: "davinci",
          object: "completion",
          created: 1_620_000_000
        },
        200
      )

    with_fixture(:post!, json, fn ->
      assert {:ok,
              %Resource{
                choices: ["Hello, World!"],
                model: "davinci",
                object: "completion",
                created: 1_620_000_000
              }} ==
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

  test ".create_stream should return a Stream reference" do
    stream = Api.create_stream(Resource, prompt: "value")

    for chunk <- stream do
      with_fixture(:post!, "", fn ->
        assert {:ok,
                %Resource{
                  choices: nil,
                  model: nil,
                  object: nil,
                  created: nil
                }} == chunk
      end)
    end
  end

  test ".create_with_file should return the file_esource if successful" do
    json =
      json_response(
        %{
          text: "Hello, World!"
        },
        200
      )

    with_fixture(:post!, json, fn ->
      assert {:ok,
              %FileResource{
                text: "Hello, World!"
              }} ==
               Api.create_with_file(FileResource, %{file: "value"}, :file)
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
end
