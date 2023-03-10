defmodule ExOpenAi.RequestTest do
  use ExUnit.Case

  defmodule TestRequest do
    use ExOpenAi.Request
  end

  test ".do_change adds to the existing map" do
    params = %{
      model: "text-model"
    }

    assert %{
      model: "text-model",
      messages: ["hello"]
    } == TestRequest.do_change(params, messages: ["hello"])
  end

  test ".do_change overrides existing data with incoming" do
    params = %{
      model: "text-model",
      messages: ["hello"]
    }

    assert %{
      model: "text-model",
      messages: ["world"]
    } == TestRequest.do_change(params, messages: ["world"])
  end

  test ".has_required_fields? returns true if all required fields are present" do
    params = %{
      model: "text-model",
      messages: ["hello"]
    }

    assert TestRequest.has_required_fields?(params, [:model, :messages])
  end

  test ".has_required_fields? returns false if any required fields are missing" do
    params = %{
      model: "text-model",
      max_tokens: 10
    }

    assert not TestRequest.has_required_fields?(params, [:model, :messages])
  end

  test ".prepare returns the params with the required fields" do
    params = %{
      model: "text-model",
      messages: ["hello"]
    }

    assert %{
      model: "text-model",
      messages: ["hello"]
    } == TestRequest.prepare(params, [], [:model, :messages])
  end

  test ".prepare returns the params with the required and optional fields" do
    params = %{
      model: "text-model",
      messages: ["hello"],
      max_tokens: 10
    }

    assert %{
      model: "text-model",
      messages: ["hello"],
      max_tokens: 10
    } == TestRequest.prepare(params, [:max_tokens], [:model, :messages])
  end

  test ".prepare removes invalid fields" do
    params = %{
      model: "text-model",
      messages: ["hello"],
      max_tokens: 10,
      invalid: "field"
    }

    assert %{
      model: "text-model",
      messages: ["hello"],
      max_tokens: 10
    } == TestRequest.prepare(params, [:max_tokens], [:model, :messages])
  end

  test ".prepare raises if required fields are missing" do
    params = %{
      model: "text-model",
      max_tokens: 10
    }

    assert_raise RuntimeError, "Required fields are missing", fn ->
      TestRequest.prepare(params, [:max_tokens], [:model, :messages])
    end
  end

  test ".delete_invalid_fields removes invalid fields" do
    params = %{
      model: "text-model",
      messages: ["hello"],
      max_tokens: 10,
      invalid: "field"
    }

    assert %{
      model: "text-model",
      messages: ["hello"],
      max_tokens: 10
    } == TestRequest.delete_invalid_fields(params, [:model, :messages, :max_tokens])
  end
end
