defmodule ExdStreams.Streams.Supervisor do
  use Supervisor
  alias ExdStreams.Streams.StreamHydrator

  def start_link(args \\ []) do
    Supervisor.start_link(__MODULE__, [args], name: __MODULE__)
  end

  def init([args]) do
    children = [
      StreamHydrator
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

end
