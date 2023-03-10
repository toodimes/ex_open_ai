defmodule ExOpenAi.ChatRequestTest do
  use ExUnit.Case
  alias ExOpenAi.ChatRequest
  alias ExOpenAi.Chat
  alias ExOpenAi.Api
  import Mock

  test ".do_append adds to the existing list" do
    params = %{
      messages: [
        %{content: "hello"}
      ]
    }

    assert %{
      messages: [
        %{content: "hello"},
        %{content: "world"}
      ]
    } == ChatRequest.do_append(params, %{content: "world"})
  end

  test ".create delegates to Api.create" do
    with_mock Api, create: fn _, _, _ -> nil end do
      params = %{
        model: "text-model",
        messages: [
          %{content: "hello"}
        ]
      }
      ChatRequest.create(params)
      assert called(Api.create(Chat, params, []))
    end
  end
end
