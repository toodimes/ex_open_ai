# ExOpenAi

ExOpenAi is an elixir wrapper for the OpenAI API. All resources return a struct of the resource that was called. 

## Installation

The package can be installed by adding `ex_open_ai` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_open_ai, "~> 0.1.0"}
  ]
end
```

## Configuration

To access the OpenAI API you will need to set the following environment or runtime variables in your `config/config.exs` file:

```elixir
config :ex_open_ai, 
  api_key: "YOUR_API_KEY_FROM_OPEN_AI",
  organization: "OPTIONAL_ORGANIZATION", # optional
  timeout: 30_000 # optional, default is 25_000
```

You can also use the `{:system, "VARIABLE_NAME"}` format.

## Usage
ExOpenAi has modules for the supported OpenAI API resource. At the time of release not all endpoints are supported, there will be more coming soon.
For example the "Completion" resource is available through the `ExOpenAi.Completion` module. Almost every single resource can be called with the `create` function. 

```elixir
iex> ExOpenAi.Chat.create(%{model: "gpt-4-turbo", [%{role: "user", content: "Tell me a funny story"}]})

{:ok, %ExOpenAi.Chat{object: "chat_cmpl", id: "cmpl-id", choices: [%{text: "funny story"}], created: 1234567890, usage: %{completion_tokens: 25, prompt_tokens: 50, total_tokens: 75}}}
```
Will return a `ExOpenAi.Chat` struct with all the information that the API returns.

## Streaming
ExOpenAi can stream tokens for Chat and Completion. 
To use it simply call `ExOpenAi.Completion.create_stream(%{model: "text-davinci-003", prompt: "Tell me a funny story"})`
This function returns a [Stream resource](https://hexdocs.pm/elixir/1.12/Stream.html#resource/3) and can be enumerated over.

The way Streams work in Elixir the code inside the Stream (the api call to OpenAi) will not be called until the Stream is "ran". 
You can do this by enumerating over the stream directly. 

An example of using the Chat stream inside LiveView:
When "creating" the stream, for example inside a phx-submit inside a form.
```
  @impl true
  def handle_event("submit_question", %{"submit_question" => question}, socket) do
    stream = ExOpenAi.Chat.create_stream(
        model: "gpt-3.5-turbo",
        messages: [
          %{content: question, role: "user"}
        ]
      )

    socket = socket
    |> assign(:question, question)
    # Allows us to listen to when the task is done.
    |> assign(:response_task, response_task(stream))

    {:noreply, socket}
  end

  defp response_task(stream) do
    target = self()

    Task.Supervisor.async(TaskSupervisor, fn ->
      for chunk <- stream do
        case chunk do
          {:done, _} -> send(target, :done)
          {:ok, parsed} -> send(target, {:cont, parsed})
        end
      end
    end)
  end
```
This will then send the tokens as they come in to the liveview page and you can handle_info them.
```
  @impl true
  def handle_info({:cont, %ExOpenAi.Chat{choices: [%{delta: %{content: content}}]}}, socket) do
    %{answer: answer} = socket.assigns
    socket = socket
    |> assign(:answer, answer <> content)

    {:noreply, socket}
  end

  # Optional
  def handle_info(:done, socket) do
    {:noreply, put_flash(socket, :info, "Done!")}
  end

  # When the Task is completed we stop listening for it. Technically not optional, but recommended if you use Task.async
  def handle_info({ref, _answer}, socket) when socket.assigns.response_task.ref == ref do
    Process.demonitor(ref, [:flush])
    {:noreply, socket}
  end

```

## Supported Resources
As of initial release the following resources are supported with more to come:

- [Chat](https://platform.openai.com/docs/api-reference/chat)
- [Edits](https://platform.openai.com/docs/api-reference/edits)
- [Embeddings](https://platform.openai.com/docs/api-reference/embeddings)
- [Image](https://platform.openai.com/docs/api-reference/images/create)
- [Whisper](https://platform.openai.com/docs/api-reference/audio/create)
- [Translation](https://platform.openai.com/docs/api-reference/audio/create)
- [Files](https://platform.openai.com/docs/api-reference/files)
- [Moderation](https://platform.openai.com/docs/api-reference/moderations)
- [Transcription](https://platform.openai.com/docs/api-reference/audio/createTranscription)
- [Model](https://platform.openai.com/docs/api-reference/models)

## Copyright and License

Copyright (c) 2023 David Astor

ExOpenAi is licensed under the MIT license. For more details see the `LICENSE` file at the root of the repo.
Elixir is licensed under the Apache 2 license.

OpenAI is a trademark of OpenAI