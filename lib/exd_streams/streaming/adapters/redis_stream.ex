defmodule ExdStreams.Streaming.RedisStream do
  @moduledoc """
  Stream implementation based on Redis streams
  """
  use ExdStreams.Streaming.StreamStore
  alias ExdStreams.Plugins.StreamPlugin.RedisPool, as: Pool

  @impl true
  def add(record) do
    RedisClient.xadd(record)
  end

  @impl true
  def read(topic, group, count, ids) do
    consumer = group
    command = ["XREADGROUP", "GROUP", group, consumer, "COUNT", count, "STREAMS", topic, "ID", ids]
    Pool.command(command)
  end

end
