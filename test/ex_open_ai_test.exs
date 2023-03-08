defmodule ExOpenAiTest do
  use ExUnit.Case
  doctest ExOpenAi

  test "greets the world" do
    assert ExOpenAi.hello() == :world
  end
end
