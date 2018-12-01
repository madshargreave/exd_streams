defmodule ExdStreams.Scheduling.HordeScheduler do
  @moduledoc """
  Schedules stream processes in cluster of connected nodes
  """
  use ExdStreams.Scheduling.Scheduler

  alias ExdStreams.StreamSupervisor
  alias ExdStreams.Streams.StreamWorker

  @impl true
  def schedule(stream) do
    Horde.Supervisor.start_child(StreamSupervisor, %{
      id: {StreamWorker, stream.id},
      start: {StreamWorker, :start_link, [stream]}
    })
  end

end
