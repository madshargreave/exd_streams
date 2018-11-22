defmodule ExdStreams.Store.RedisStore do
  @moduledoc """
  A redis-based state store

  The Redis store implementation uses the Redis set datastructure
  to store and retrieve records
  """
  alias ExdStreams.Store, as: BaseStore
  alias ExdStreams.Store.KeyValueStore
  use KeyValueStore

  defstruct [:prefix, :conn]

  @impl BaseStore
  def init(opts) do
    prefix = Keyword.fetch!(opts, :prefix)
    conn = Keyword.fetch!(opts, :conn)
    state = %__MODULE__{prefix: prefix, conn: conn}
    {:ok, state}
  end

  @impl BaseStore
  def name do
    :redis_store
  end

  @impl KeyValueStore
  def all(state) do
    command = ["SCAN"]
    Redix.command(state.conn, command)
  end

  @impl KeyValueStore
  def get(key, state) do
    prefixed = prefixed_key(state.prefix, key)
    command = ["GET", prefixed]
    Redix.command(state.conn, command)
  end

  @impl KeyValueStore
  def put(key, value, state) do
    prefixed = prefixed_key(state.prefix, key)
    command = ["SET", prefixed, value]
    Redix.command(state.conn, command)
  end

  @impl KeyValueStore
  def put_all(keys_and_values, state) do
    commands =
      for {key, value} <- keys_and_values do
        prefixed = prefixed_key(state.prefix, key)
        ["SET", prefixed, value]
      end
    Redix.pipeline(state.conn, commands)
  end

  @impl KeyValueStore
  def delete(key, state) do
    prefixed = prefixed_key(state.prefix, key)
    Redix.command(state.conn, "DELETE", prefixed)
  end

  defp prefixed_key(prefix, key) do
    "#{prefix}:#{key}"
  end

end
