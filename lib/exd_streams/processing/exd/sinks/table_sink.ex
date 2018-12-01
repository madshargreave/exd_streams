defmodule Exd.Plugin.TableSink do
  @moduledoc """
  Plugin that materialised a stream of records into a table
  """
  use GenStage
  use Exd.Plugin

  alias ExdStreams.Processing.Store

  # Client

  def start_link(opts \\ []) do
    GenStage.start_link(__MODULE__, opts)
  end

  @impl true
  def handle_parse({:table, table_name}), do: handle_parse({:table, table_name, []})
  def handle_parse({:table, table_name, opts}) do
    opts = Keyword.put(opts, :table_name, table_name)
    spec = {__MODULE__, opts}
    {:ok, spec}
  end

  # Server

  @impl true
  def init(opts) do
    table_name = Keyword.fetch!(opts, :table_name)
    table = %{name: table_name}
    state = %{table: table}
    {:producer_consumer, state}
  end

  @impl true
  def handle_events(records, _from, state) do
    Store.put_all(state.table, records)
    {:noreply, records, state}
  end

  @impl true
  def handle_cancel(_, _from, state) do
    GenStage.async_info(self(), :terminate)
    {:noreply, [], state}
  end

  @impl true
  def handle_info(:terminate, state) do
    {:stop, :shutdown, state}
  end

end
