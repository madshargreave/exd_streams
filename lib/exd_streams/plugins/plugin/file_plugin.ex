defmodule ExdStreams.Query.FilePlugin do
  @moduledoc """
  Plugin that joins a stream of data with a persisted materialised view
  """
  use Exd.Plugin

  alias ExdStreams.Plugins.Dispatcher
  alias ExdStreams.Processing.Writer

  defmodule State do
    defstruct [:table, :meta, :count, :start_at]
  end

  # Client

  @impl true
  def name do
    :table
  end

  # Server

  @impl true
  def init(%Exd.Context{env: opts} = context) do
    table = Keyword.fetch!(opts, :table)

    count = 0
    start_at = NaiveDateTime.utc_now

    state = %State{table: table, meta: opts, count: count, start_at: start_at}
    {:producer_consumer, state}
  end

  @impl true
  def handle_demand(demand, state) do
    {:noreply, [], state}
  end

  @impl true
  def handle_events(events, _from, state) do
    transformed_events =
      for event <- events do
        key =
          case event do
            %{"_key" => nil} ->
              UUID.uuid4()
            %{"_key" => ""} ->
              UUID.uuid4()
            %{"_key" => key} when is_integer(key) ->
              UUID.uuid5(state.table, Integer.to_string(key))
            %{"_key" => key} when is_binary(key) ->
              UUID.uuid5(state.table, key)
            _ ->
              UUID.uuid4()
          end
        # event = Map.put_new(event, "_ts", NaiveDateTime.utc_now())
        %{
          state: ExdStreams.Plugins.Utils.hash_state(Poison.encode!(event)),
          table_id: state.table,
          key: key,
          value: event,
          ts: NaiveDateTime.utc_now()
        }
      end

    temporary = Keyword.fetch!(state.meta, :temporary)
    Dispatcher.dispatch(%{
      type: :records_created,
      table_id: state.table,
      temporary: temporary,
      records: transformed_events
    })
    count = length(transformed_events) + state.count
    {:noreply, transformed_events, %State{state | count: count}}
  end

  @impl true
  def handle_cancel(_, _from, state) do
    GenStage.async_info(self(), :terminate)
    {:noreply, [], state}
  end

  @impl true
  def handle_info(:terminate, state) do
    event = make_event(state)
    Dispatcher.dispatch(event)
    {:stop, :normal, state}
  end

  defp make_event(state) do
    end_at = NaiveDateTime.utc_now
    event = %{
      type: :query_done,
      meta: state.meta,
      count: state.count,
      start_at: state.start_at,
      end_at: end_at
    }
  end

end
