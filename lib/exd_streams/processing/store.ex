defmodule ExdStreams.Processing.Store do
  @moduledoc """
  Delegates persistence to state stores
  """
  alias ExdStreams.Processing.Stores.{IndexedStore, MaterialStore}
  alias ExdStreams.Tables.Table

  @doc """
  Saves records to table
  """
  def put_all(table, records) do
    keys_and_values = for record <- records, do: {record.key, record.value}
    if Table.indexed?(table) do
      IndexedStore.put_all(table.name, keys_and_values)
    else
      MaterialStore.put_all(table.name, keys_and_values)
    end
  end

end
