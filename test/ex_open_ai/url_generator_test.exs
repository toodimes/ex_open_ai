defmodule ExOpenAi.UrlGeneratorTest do
  use ExUnit.Case

  import ExOpenAi.URLGenerator

  alias ExOpenAi.Completion

  doctest ExOpenAi.URLGenerator

  test "generates a url for a completion" do
    assert infer_url(Completion) =~ "v1/completions"
  end

  test "generates a url for a new image" do
    assert infer_url(ExOpenAi.NewImage) =~ "v1/images/generations"
  end

  test "genearates a url for a chat" do
    assert infer_url(ExOpenAi.Chat) =~ "v1/chat/completions"
  end
end
