defmodule ExdStreams do
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
      supervisor(ExdStreamsCluster.Supervisor, []),
      supervisor(ExdStreams.Api.Supervisor, []),
      supervisor(ExdStreams.Supervisor, []),
    ]

    opts = [strategy: :one_for_one, name: ExdStreams.ApplicationSupervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ExdStreamsWeb.Endpoint.config_change(changed, removed)
    :ok
  end

end
