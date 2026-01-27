defmodule Fretwire.MixProject do
  use Mix.Project

  def project do
    [
      app: :fretwire,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      c: [
        "compile"
      ],
      check: [
        "format --check-formatted",
        "credo -a --strict",
        "dialyzer"
      ],
      test: [
        "test --warnings-as-errors"
      ]
    ]
  end
end
