defmodule ExdStreams.Streaming.StreamStore do
  @moduledoc """
  A behaviour for key-value based state stores
  """
  alias Exd.Query

  @doc """
  Adds a record to stream
  """
  @callback add(Query.t) :: {:ok, map()}

  @doc """
  Reads one or more from stream as a consumer in group
  """
  @callback read(Query.t) :: {:ok, map()}

  defmacro __using__(_opts) do
    quote do
      @behaviour ExdStreams.Store.BaseStore
    end
  end

end
