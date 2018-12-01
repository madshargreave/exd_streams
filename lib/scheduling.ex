defmodule ExdStreams.Scheduling do
  @moduledoc """
  Context of process scheduling
  """
  alias ExdStreams.Scheduling.HordeScheduler, as: DefaultImpl

  @scheduler Application.get_env(:exd_streams, :stream_store_impl) || DefaultImpl

  @doc """
  Schedule stream as a distributed and supervised process
  """
  def schedule(stream) do
    @scheduler.schedule(stream)
  end

end
