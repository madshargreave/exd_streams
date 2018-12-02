defmodule ExdStreams.Processing.Handler do
  @moduledoc false
  use GenConsumer, otp_app: :exd_streams

  alias ExdStreams.Scheduling
  alias ExdStreams.Streams.Stream
  alias ExdStreams.Tables.Table
  alias ExdStreams.Query.Builder

  @impl true
  def handle({:created, %Table{query: query} = table})
    when not is_nil(query)
  do
    for query <- [
      get_stream_query(table),
      get_table_query(table)
    ]
    do
      Scheduling.schedule(query)
    end
  end

  @impl true
  def handle({:created, %Stream{} = stream}) do
    Scheduling.schedule(stream.query)
  end

  @impl true
  def handle({:dropped, %Table{} = table}) do
    Scheduling.cancel(table.id)
  end

  @impl true
  def handle({:dropped, %Stream{} = stream}) do
    Scheduling.cancel(stream.id)
  end

  defp get_stream_query(table) do
    table.query
  end

  defp get_table_query(table) do
    Builder.into_table(table)
  end

end
