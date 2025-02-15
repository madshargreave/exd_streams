defmodule ExdStreams.Streaming.Plugins.Supervisor do
  use Supervisor
  alias ExdStreams.Query.StreamPlugin.Redix, as: RedixPool

  def start_link(args) do
    Supervisor.start_link(__MODULE__, [args], name: __MODULE__)
  end

  def init([args]) do
    children = [
      RedixPool
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

end
