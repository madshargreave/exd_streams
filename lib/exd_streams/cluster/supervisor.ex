defmodule ExdStreams.Cluster.Supervisor do
  @moduledoc """
  Cluster supervisor
  """
  use Supervisor

  alias ExdStreams.Cluster.{
    HordeConnector,
    MnesiaConnector
  }

  # Node hosts
  @hosts [:"node1@Madss-MacBook-Pro-2", :"node2@Madss-MacBook-Pro-2"]

  # Cluster connectors
  @connectors [
    HordeConnector,
    # MnesiaConnector
  ]

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
        id: ExdStreams.Cluster.HordeConnector,
        restart: :transient,
        start: {
          Task,
          :start_link,
          [
            fn ->
              for connector <- @connectors, do: connector.connect()
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
        config: [hosts: @hosts]
      ]
    ]
  end

end
