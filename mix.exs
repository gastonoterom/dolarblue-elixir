defmodule Dolarblue.MixProject do
  use Mix.Project

  def project do
    [
      app: :dolarblue,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :cowboy, :plug, :poison],
      mod: {Dolarblue.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:floki, "~> 0.26.0"},
      {:poison, "~> 5.0"},
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.5"},
      {:plug_cowboy, "~> 1.0"}
    ]
  end
end
