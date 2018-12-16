defmodule ExdStreams.Store.Mnesia do
  @moduledoc """
  A Mnesia based state store
  """
  use ExdStreams.Store.KeyValueStore

  alias :mnesia, as: Mnesia
  alias ExdStreams.Store.BaseStore
  alias ExdStreams.Store.KeyValueStore

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  @impl BaseStore
  def init(opts) do
    Mnesia.start()
    Mnesia.create_table(:record, [attributes: [:id, :data]])
    state = %{}
    {:ok, state}
  end

  @impl BaseStore
  def name do
    :mnesia_store
  end

  @impl KeyValueStore
  def all(table) do
    ops = fn -> Mnesia.match_object({table, :_, :_}) end
    case Mnesia.transaction(ops) do
      {:atomic, results} ->
        convert(results)
    end
  end

  @impl KeyValueStore
  def get(table, key) do
    ops = fn -> Mnesia.match_object({table, key, :_}) end
    case Mnesia.transaction(ops) do
      {:atomic, [result]} ->
        {:ok, convert(result)}
      {:atomic, []} ->
        {:error, :not_found}
    end
  end

  @impl KeyValueStore
  def put(table, key, value) do
    put_all(table, [{key, value}])
  end

  @impl KeyValueStore
  def put_all(table, keys_and_values) do
    ops =
      fn ->
        for {key, value} <- keys_and_values do
          Mnesia.write({table, key, value})
        end
      end
    case Mnesia.transaction(ops) do
      {:atomic, results} when is_list(results) ->
        {:ok, length(results)}
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
