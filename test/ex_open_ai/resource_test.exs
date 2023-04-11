defmodule ExOpenAi.ResourceTest do
  use ExUnit.Case
  alias ExOpenAi.Api
  import Mock

  defmodule TestResource do
    defstruct choices: nil, object: nil, id: nil
    use ExOpenAi.Resource, import: [:new, :create, :create_stream]
    def keep_it_simple(response, true), do: Enum.map(response.choices, &Map.get(&1, :text))
    def keep_it_simple(response, _), do: response
  end

  test "only imports correct methods" do
    defmodule LimitedResource do
      defstruct choices: nil, object: nil, id: nil
      use ExOpenAi.Resource, import: [:new]
    end

    Enum.each([:create], fn method ->
      assert_raise UndefinedFunctionError, fn ->
        apply(LimitedResource, method, ["id"])
      end
    end)
  end

  test ".new should return the struct" do
    assert %TestResource{} == TestResource.new()
    assert %TestResource{choices: "hello"} == TestResource.new(choices: "hello")
  end

  test ".create delegates to Api.create" do
    with_mock Api, create: fn _, _, _ -> nil end do
      TestResource.create(prompt: "value")
      assert called(Api.create(TestResource, [prompt: "value"], []))
    end
  end

  test ".create_stream delegates to Api.create_stream" do
    with_mock Api, create_stream: fn _, _, _ -> nil end do
      TestResource.create_stream(prompt: "value")
      assert called(Api.create_stream(TestResource, [prompt: "value"], []))
    end
  end

  test "keep_it_simple returns only list" do
    response = %TestResource{
      choices: [
        %{index: 0, text: "hello"},
        %{index: 1, text: "world"}
      ],
      id: "cmpl-123",
      object: "text_completion"
    }

    assert ["hello", "world"] == TestResource.keep_it_simple(response, true)
  end

  test "keep_it_simple returns full response" do
    response = %TestResource{
      choices: [
        %{index: 0, text: "hello"},
        %{index: 1, text: "world"}
      ],
      id: "cmpl-123",
      object: "text_completion"
    }

    assert response == TestResource.keep_it_simple(response, false)
  end
end
