defmodule ExdStreams.Scheduling.Scheduler do
  @moduledoc """
  Behaviour for process schedulers
  """
  alias ExdStreams.Streams.Stream

  @doc """
  Schedule processes on a node in cluster
  """
  @callback schedule(Stream.t) :: :ok | {:error, term}

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour ExdStreams.Scheduling.Scheduler
    end
  end

end
