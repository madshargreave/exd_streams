defmodule ExdStreams.Plugins.Supervisor do
  use Supervisor
  alias ExdStreams.Plugins.Dispatcher

  def start_link(args \\ []) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(args) do
    children = [
      supervisor(Phoenix.PubSub.PG2, [:pubsub, [pool_size: 1]]),
      Dispatcher
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

end
