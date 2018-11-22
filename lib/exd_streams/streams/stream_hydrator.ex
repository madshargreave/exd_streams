defmodule ExdStreams.Streams.StreamHydrator do
  @moduledoc """
  Restarts all stream processes
  """
  require Logger
  use GenServer
  alias ExdStreams.Streams.{StreamScheduler, StreamService}

  # Client

  def child_spec(opts \\ []) do
    %{
      id: __MODULE__,
      start: {
        Task,
        :start_link,
        [
          fn -> __MODULE__.hydrate(opts) end
        ]
      },
      restart: :transient
    }
  end

  def hydrate(opts \\ []) do
    connected? = length(Node.list()) > 0
    if !connected? do
      :timer.sleep(2000)
      Logger.info "[#{node()}] Hydrating stream processes"
      streams = StreamService.list()
      pids =
        for stream <- streams do
          StreamScheduler.schedule(stream)
        end
        |> Enum.reject(&Kernel.match?({:error, _}, &1))
        |> Enum.map(&elem(&1, 1))

      Logger.info "[#{node()}] Succesfully hydrated #{length pids} stream processes"
    end
  end

end
