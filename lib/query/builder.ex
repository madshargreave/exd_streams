defmodule ExdStreams.Query.Builder do
  @moduledoc """
  This module includes functionality for working with Exd queries in
  the context of streams and tables
  """
  alias Exd.Query

  def into_table(%Query{} = query, table_name) do
    sink_spec = {:table, [name: table_name]}
    Query.into(query, sink_spec)
  end

  def into_action(%Query{} = query, table_name) do
    sink_spec = {:action, [name: table_name]}
    Query.into(query, sink_spec)
  end

end
