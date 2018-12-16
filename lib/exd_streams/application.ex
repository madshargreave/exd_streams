defmodule ExdStreams.Application do
  @moduledoc """
  ExdStreams keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(ExdStreams.Cluster.Supervisor, []),
      supervisor(ExdStreams.Connection.Supervisor, []),
      supervisor(ExdStreams.Processing.Supervisor, []),
      supervisor(ExdStreams.Plugins.Supervisor, []),
      supervisor(ExdStreams.Core.Supervisor, []),
      supervisor(ExdStreams.Store.RelationalStore.RecordRepo, []),
      worker(ExdStreams.Store.RelationalStore, []),
      worker(ExdStreams.Store.Mnesia, [])
    ]

    opts = [strategy: :one_for_one, name: ExdStreams.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
