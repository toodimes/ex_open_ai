defmodule ExOpenAi.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_open_ai,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:httpoison, "~> 2.0"},
      {:jason, "~> 1.2"},
      {:mock, "~> 0.3", only: :test}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp description do
    "A client for the OpenAI API"
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
