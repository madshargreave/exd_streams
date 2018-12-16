defmodule ExdStreams.Processing.Supervisor do
  use Supervisor

  alias ExdStreams.Processing.Stores.MaterialStore
  alias ExdStreams.Processing.Writer

  def start_link(args \\ []) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(args) do
    children = [
      # MaterialStore,
      Writer
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

end
