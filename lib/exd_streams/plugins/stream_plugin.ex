defmodule ExdStreams.Query.StreamPlugin do
  @moduledoc """
  Plugin that joins a stream of data with a persisted materialised view
  """
  use Exd.Plugin
  use GenStage

  defmodule State do
    defstruct [:topic, :group, :poll_interval, :pending_demand]
  end

  # Client

  def start_link(opts \\ []) do
    GenStage.start_link(__MODULE__, opts)
  end

  @impl true
  def handle_parse({:stream, stream_name}) do
    opts = Keyword.put(opts, :stream_name, stream_name)
    spec = {__MODULE__, opts}
    {:ok, spec}
  end

  # Server

  @impl true
  def init([mode: :source] = opts) do
    topic = Keyword.fetch!(opts, :stream_name)
    poll_interval = Keyword.get(opts, :poll_interval, 1000)
    state = %State{
      topic: topic,
      group: self(),
      poll_interval: poll_interval,
      pending_demand: 0
    }
    Process.send_after(self(), :poll, state.poll_interval)
    {:producer, state}
  end

  @impl true
  def init([mode: :sink]) do
    state = %{}
    {:producer_consumer, state}
  end

  @impl true
  def handle_demand(demand, state) do
    new_state = %State{state | pending_demand: state.pendind_demand + demand}
    {:noreply, [], new_state}
  end

  @impl true
  def handle_events(events, state) do
    RedisClient.add(events)
    {:noreply, events, state}
  end

  @impl true
  def handle_info(:poll, state) do
    events = fetch_events(state)
    new_state = %State{state | pending_demand: state.pendind_demand - length(events)}
    Process.send_after(self(), :poll, state.poll_interval)
    {:noreply, events, new_state}
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

  defp fetch_events(%{pending_demand: demand} state) when demand > 0,
    do: RedisClient.read(state.topic, state.group, demand)
  defp fetch_events(_),
    do: []

end
