defmodule Cam.MixProject do
  use Mix.Project

  def project do
    [
      app: :cam,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Cam.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:muontrap, "~> 1.0"},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.3"}
    ]
  end
end
