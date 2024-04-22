defmodule ExOpenAi.MixProject do
  use Mix.Project

  @version "2.0.1"

  def project do
    [
      app: :ex_open_ai,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.27", only: [:dev, :test], runtime: false},
      # HTTPoison is only used for streaming responses. Tesla does not have satisfactory support for streaming responses.
      {:httpoison, "~> 2.0"},
      {:jason, "~> 1.2"},
      {:mock, "~> 0.3", only: :test},
      {:dialyxir, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:tesla, "~> 1.9"}
    ]
  end

  defp docs do
    [
      extras: [
        LICENSE: [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: "https://github.com/toodimes/ex_open_ai",
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end

  defp description do
    "An elixir client for the OpenAI API."
  end

  defp package do
    [
      maintainers: ["David Astor"],
      licenses: ["MIT"],
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      links: %{
        "GitHub" => "https://github.com/toodimes/ex_open_ai"
      }
    ]
  end
end
