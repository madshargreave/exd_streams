defmodule ExdStreams.Processing.Supervisor do
  use Supervisor
  alias ExdStreams.Processing.Stores.MaterialStore

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(args) do
    children = [
      MaterialStore
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

end
