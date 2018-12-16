# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :exd_streams, ExdStreamsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "CoCxGbgnOee4GtPP+ZWdIlwfCkkqW60rxjwv83oH8LaNT/MjANOeTitoJiS8yEas",
  render_errors: [view: ExdStreamsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ExdStreams.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :mnesia,
   dir: 'priv/data/#{Mix.env}'

config :ecto_mnesia,
  host: {:system, :atom, "MNESIA_HOST", Kernel.node()},
  storage_type: {:system, :atom, "MNESIA_STORAGE_TYPE", :disc_only_copies}

config :exd_streams, ecto_repos: [ExdStreams.Core.Repo]
config :exd_streams, ExdStreams.Core.Repo,
  adapter: Ecto.Adapters.Postgres

# Core
config :exd_streams, ExdStreams.Core.Dispatcher,
  adapter: GenDispatcher.LocalDispatcher

# Processing
config :exd_streams, ExdStreams.Processing.MaterialStore,
  adapter: ExdStreams.Store.Mnesia

config :exd_streams, ExdStreams.Store.RelationalStore.RecordRepo,
  adapter: Ecto.Adapters.Postgres

config :exd,
  plugins: [
    Exd.Plugin.RedisStream,
    Exd.Plugin.TableSink
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
