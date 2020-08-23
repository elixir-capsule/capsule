defmodule Capsule.MixProject do
  use Mix.Project

  def project do
    [
      app: :capsule,
      description: "Uploaded file management for Elixir",
      version: "0.5.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      name: "Capsule",
      source_url: "https://github.com/elixir-capsule/capsule",
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :inets]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false, plt_cor_path: "_build/#{Mix.env()}"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      maintainers: ["Thomas Floyd Wright"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/elixir-capsule/capsule"}
    ]
  end
end
