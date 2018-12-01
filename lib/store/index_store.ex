defmodule ExdStreams.Store.IndexStore do
  @moduledoc """
  A behaviour for key-value based state stores
  """
  alias Exd.Query

  @doc """
  Translates query AST into store implementation and executes result
  """
  @callback search(Query.t) :: {:ok, map()}

  defmacro __using__(_opts) do
    quote do
      @behaviour ExdStreams.Store
      @behaviour ExdStreams.Store.KeyValueStore
      @behaviour ExdStreams.Store.IndexStore
    end
  end

end
