defmodule ExdStreams.Streams.StreamService do
  @moduledoc """
  Streams service
  """
  alias ExdStreams.Streams.Store.MnesiaImpl, as: DefaultImpl
  alias ExdStreams.Streams.{
    Stream,
    StreamScheduler
  }

  @store Application.get_env(:exd_streams, :stream_store_impl) || DefaultImpl

  @doc """
  List all streams
  """
  def list(role) do
    @store.list()
  end

  @doc """
  List all user streams
  """
  def list(role) do
    @store.list(role.id)
  end

  @doc """
  Return a single stream
  """
  def get(role, stream_id) do
    @store.get(stream_id)
  end

  @doc """
  Create and register a new stream
  """
  def create(role, attrs \\ %{}) do
    stream = Stream.make(role, attrs)
    saved = @store.save(stream)
    StreamScheduler.schedule(stream)
    saved
  end

  @doc """
  Drops an existing stream
  """
  def drop(role, name) do
    stream = get(role, name)
    @store.delete(stream)
  end

end
