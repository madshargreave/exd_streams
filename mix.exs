defmodule ExdStreams.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exd_streams,
      version: "0.0.1",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env),
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
      {:exd, path: "../exd"},
      {:gen_buffer, path: "../gen_buffer"},
      {:exd_redis, path: "../exd_plugin_redis"},
      {:gen_dispatcher, "~> 0.2.0"},
      {:ecto_mnesia, "~> 0.9.0"},
      {:ecto, "~> 2.1.6"},
      {:redix, ">= 0.0.0"},
      {:iteraptor, "~> 1.0.0"},
      # {:mnesia_rocksdb, git: "git@github.com:arpunk/mnesia_rocksdb.git", tag: "include-sext"},
      # {:sext, "~> 1.4", manager: :rebar, override: true},
      {:horde, "~> 0.3.0"},
      {:libcluster, "~> 3.0.1"},
      {:event_bus, "~> 1.6.0"},
      {:uuid, "~> 1.1.8"},
      {:phoenix, "~> 1.3.3"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:cowboy, "~> 1.0"}
    ]
  end
end
