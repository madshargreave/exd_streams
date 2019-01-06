defmodule ExdStreams.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exd_streams,
      version: "0.0.3",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env),
      description: description(),
      package: package(),
      compilers: [:phoenix] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ExdStreams.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:exd, "~> 0.1.29"},
      {:gen_buffer, "~> 0.1.0"},
      {:gen_dispatcher, ">= 0.0.0"},
      {:ecto_mnesia, "~> 0.9.0"},
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 2.1.6"},
      {:redix, ">= 0.0.0"},
      {:iteraptor, "~> 1.0.0"},
      {:horde, "~> 0.3.0"},
      {:libcluster, "~> 3.0.1"},
      {:event_bus, "~> 1.6.0"},
      {:elixir_uuid, "~> 1.2"},
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description() do
    "Utilities for working with Exd streams"
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "exd_streams",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README*),
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/madshargreave/exd_streams"}
    ]
  end

end
