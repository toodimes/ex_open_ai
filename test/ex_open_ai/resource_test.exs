defmodule ExOpenAi.ResourceTest do
  use ExUnit.Case
  alias ExOpenAi.Api
  import Mock

  defmodule TestResource do
    defstruct choices: nil, object: nil, id: nil
    use ExOpenAi.Resource, import: [:new, :create]
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
end
