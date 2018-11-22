defmodule ExdStreamsCluster.Supervisor do
  @moduledoc """
  Cluster supervisor
  """
  use Supervisor

  def start_link(args \\ []) do
    Supervisor.start_link(__MODULE__, [args], name: __MODULE__)
  end

  def init([args]) do
    children = [
      {Cluster.Supervisor, [topologies(), [name: ExdStreams.NodeSupervisor]]},
      {Horde.Registry, name: ExdStreams.StreamRegistry, keys: :unique},
      {
        Horde.Supervisor,
        [
          name: ExdStreams.StreamSupervisor,
          strategy: :one_for_one,
          distribution_strategy: Horde.UniformQuorumDistribution
        ]
      },
      %{
        id: ExdStreamsCluster.HordeConnector,
        restart: :transient,
        start: {
          Task,
          :start_link,
          [
            fn ->
              ExdStreamsCluster.HordeConnector.connect()
              ExdStreamsCluster.MnesiaConnector.connect()
            end
          ]
        }
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp topologies do
    [
      example: [
        strategy: Cluster.Strategy.Epmd,
        config: [hosts: [:"node1@Madss-MacBook-Pro-2", :"node2@Madss-MacBook-Pro-2"]]
      ]
    ]
  end

end
