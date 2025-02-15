defmodule ExdStreams.Connection.Supervisor do
  @moduledoc false
  use Supervisor

  def start_link(args \\ []) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(args) do
    children = [
      {Registry, name: ExdStreams.Connection.Sessions.SessionRegistry, keys: :unique},
      {ExdStreams.Connection.Sessions.Supervisor, []}
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end

end
