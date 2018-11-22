defmodule ExdStreams.Streams.StreamService do
  @moduledoc """
  Jobs service
  """
  alias ExdStreams.Streams
  alias ExdStreams.Streams.Store.MnesiaImpl, as: DefaultImpl
  alias ExdStreams.Streams.{
    Stream,
    StreamStore,
    StreamScheduler
  }

  @store Application.get_env(:exd_streams, :stream_store_impl) || DefaultImpl

  @doc """
  List all streams
  """
  def list do
    @store.list()
  end

  @doc """
  List all user streams
  """
  def list(user_id) do
    @store.list(user_id)
  end

  @doc """
  Return a single stream
  """
  def get(stream_id) do
    @store.get(stream_id)
  end

  @doc """
  Create and register a new stream
  """
  def create(attrs \\ %{}) do
    stream = Stream.make(attrs)
    saved = @store.save(stream)
    StreamScheduler.schedule(stream)
    saved
  end

end
