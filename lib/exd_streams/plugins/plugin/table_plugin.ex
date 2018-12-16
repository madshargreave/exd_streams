defmodule ExdStreams.Query.TablePlugin do
  @moduledoc """
  Plugin that joins a stream of data with a persisted materialised view
  """
  use Exd.Plugin
  use GenStage

  alias ExdStreams.Plugins.Dispatcher
  alias ExdStreams.Processing.Writer

  defmodule State do
    defstruct [:meta, :count, :start_at]
  end

  # Client

  def start_link(opts \\ []) do
    GenStage.start_link(__MODULE__, opts)
  end

  @impl true
  def handle_parse({:table, table_name}) do
    opts = [table_name: table_name]
    spec = {__MODULE__, opts}
    {:ok, spec}
  end

  # Server

  @impl true
  def init(opts) do
    mode = Keyword.fetch!(opts, :mode)
    meta = Keyword.get(opts, :meta, %{})

    count = 0
    start_at = NaiveDateTime.utc_now

    state = %State{meta: meta, count: count, start_at: start_at}
    do_init(mode, state)
  end
  defp do_init(:source, state), do: {:producer, state}
  defp do_init(:sink, state), do: {:producer_consumer, state}

  @impl true
  def handle_demand(demand, state) do
    {:noreply, [], state}
  end

  @impl true
  def handle_events(events, _from, state) do
    Writer.add(events)
    count = length(events) + state.count
    {:noreply, events, %State{state | count: count}}
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
