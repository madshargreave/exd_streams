defmodule ExdStreams.Streams.StreamScheduler do
  @moduledoc """
  Schedules stream processes in cluster of connected nodes
  """
  alias ExdStreams.{StreamRegistry, StreamSupervisor}
  alias ExdStreams.Streams.StreamWorker

  @doc """
  Schedule stream process
  """
  def schedule(stream) do
    Horde.Supervisor.start_child(StreamSupervisor, %{
      id: {StreamWorker, stream.id},
      start: {StreamWorker, :start_link, [stream]}
    })
  end

end
