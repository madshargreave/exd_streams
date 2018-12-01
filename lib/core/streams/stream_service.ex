defmodule ExdStreams.Streams.StreamService do
  @moduledoc """
  Streams service
  """
  alias ExdStreams.Core.Dispatcher, as: DefaultDispatcher
  alias ExdStreams.Scheduling
  alias ExdStreams.Streams.Store.MnesiaImpl, as: DefaultImpl
  alias ExdStreams.Streams.{
    Stream
  }

  @store Application.get_env(:exd_streams, :stream_store_impl) || DefaultImpl
  @dispatcher Application.get_env(:exd_streams, :dispatcher_impl) || DefaultDispatcher

  @doc """
  List all user streams
  """
  def list(%{system: true} = role), do: @store.list()
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
    changeset = Stream.create_changeset(role, attrs)
    stream = @store.save!(changeset)
    @dispatcher.dispatch({:created, stream}, [])
    stream
  end

  @doc """
  Drops an existing stream
  """
  def drop(role, name) do
    stream = get(role, name)
    @store.delete(stream)
    @dispatcher.dispatch({:dropped, stream}, [])
    stream
  end

end
