defmodule DirCleaner.MixProject do
  use Mix.Project

  @version File.read!("VERSION") |> String.trim()
  @source_url "https://github.com/guenni68/dir_cleaner.git"

  def project do
    [
      app: :dir_cleaner,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      source_url: @source_url,
      homepage_url: @source_url,
      docs: [
        # The main page in the docs
        main: "DirCleaner"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {DirCleaner.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.29.1", only: :dev, runtime: false}
    ]
  end

  defp description() do
    """
    DirCleaner is a simple-to-use utility to automatically
    remove stale or temporary files from specified directories
    """
  end

  defp package() do
    [
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url}
    ]
  end
end
