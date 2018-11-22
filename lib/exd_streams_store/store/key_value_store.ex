defmodule ExdStreams.Store.KeyValueStore do
  @moduledoc """
  A behaviour for key-value based state stores
  """

  @typep key :: binary
  @typep value :: any

  @doc """
  Return an iterator over all keys in this store.
  """
  @callback all() :: {:ok, Stream.t}

  @doc """
  Get the value corresponding to this key.
  """
  @callback get(key) :: {:ok, value}

  @doc """
  Update the value associated with this key
  """
  @callback put(key, value) :: :ok | {:error, term}

  @doc """
  Update all the given key/value pairs
  """
  @callback put_all([key, value]) :: :ok | {:error, term}

  @doc """
  Delete the value from the store if one is present
  """
  @callback delete(key) :: :ok | {:error, term}

  defmacro __using__(_opts) do
    quote do
      @behaviour ExdStreams.Store
      @behaviour ExdStreams.Store.KeyValueStore
    end
  end

end
