defmodule ExdStreams.Streams.Store.MnesiaImpl do
  @moduledoc false
  alias :mnesia, as: Mnesia
  alias ExdStreams.Streams.Stream

  @behaviour ExdStreams.Streams.StreamStore

  @impl true
  def list do
    ops = fn -> Mnesia.match_object({:streams, :_, :_, :_, :_, :_}) end
    case Mnesia.transaction(ops) do
      {:atomic, results} ->
        convert(results)
    end
  end

  @impl true
  def list(role_id) do
    ops = fn -> Mnesia.match_object({:streams, :_, role_id, :_, :_, :_}) end
    case Mnesia.transaction(ops) do
      {:atomic, results} ->
        convert(results)
    end
  end

  @impl true
  def get(stream_id) do
    ops = fn -> Mnesia.match_object({:streams, stream_id, :_, :_, :_, :_}) end
    case Mnesia.transaction(ops) do
      {:atomic, [result]} ->
        {:ok, convert(result)}
      {:atomic, []} ->
        {:error, :not_found}
    end
  end

  @impl true
  def save(stream) do
    ops =
      fn ->
        Mnesia.write({:streams, stream.id, stream.role_id, stream.name, stream.query, stream.created_at})
      end
    case Mnesia.transaction(ops) do
      {:atomic, :ok} ->
        {:ok, stream}
    end
  end

  @impl true
  def drop(stream_id) do

  end

  defp convert(%Stream{} = stream) do
    {:streams, stream.id, stream.role_id, stream.name, stream.query, stream.created_at}
  end
  defp convert(streams) when is_list(streams), do: for stream <- streams, do: convert(stream)
  defp convert({
    _table,
    id,
    role_id,
    name,
    query,
    created_at
  }) do
    %Stream{
      id: id,
      role_id: role_id,
      name: name,
      query: query,
      created_at: created_at
    }
  end

end
