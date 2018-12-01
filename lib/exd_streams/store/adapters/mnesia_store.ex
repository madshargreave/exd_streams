defmodule ExdStreams.Store.Mnesia do
  @moduledoc """
  A Mnesia based state store
  """
  use ExdStreams.Store.KeyValueStore

  alias :mnesia, as: Mnesia
  alias ExdStreams.Store.BaseStore
  alias ExdStreams.Store.KeyValueStore

  @impl BaseStore
  def init(opts) do
    Mnesia.start()
    state = %{}
    {:ok, state}
  end

  @impl BaseStore
  def name do
    :mnesia_store
  end

  @impl KeyValueStore
  def all(state) do
    ops = fn -> Mnesia.match_object({state.table, :_, :_}) end
    case Mnesia.transaction(ops) do
      {:atomic, results} ->
        convert(results)
    end
  end

  @impl KeyValueStore
  def get(key, state) do
    ops = fn -> Mnesia.match_object({state.table, key, :_}) end
    case Mnesia.transaction(ops) do
      {:atomic, [result]} ->
        {:ok, convert(result)}
      {:atomic, []} ->
        {:error, :not_found}
    end
  end

  @impl KeyValueStore
  def put(key, value, state) do
    put_all([{key, value}], state)
  end

  @impl KeyValueStore
  def put_all(keys_and_values, state) do
    ops =
      fn ->
        for {key, value} <- keys_and_values do
          Mnesia.write({state.table, key, value})
        end
      end
    case Mnesia.transaction(ops) do
      {:atomic, :ok} ->
        {:ok, length(keys_and_values)}
    end
  end

  @impl KeyValueStore
  def delete(key, state) do
    raise "delete/2 not implemented"
  end

  defp convert(results) do
    results
  end

end
