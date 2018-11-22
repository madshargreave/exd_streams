defmodule ExdStreamsCluster.HordeConnector do
  @moduledoc """
  Module responsible for connecting hordes
  """
  require Logger

  @doc """
  Connects hordes
  """
  def connect do
    Node.list()
    |> Enum.each(fn node ->
      Horde.Cluster.join_hordes(ExdStreams.StreamSupervisor, {ExdStreams.StreamSupervisor, node})
      Horde.Cluster.join_hordes(ExdStreams.StreamRegistry, {ExdStreams.StreamRegistry, node})
    end)
  end

end
