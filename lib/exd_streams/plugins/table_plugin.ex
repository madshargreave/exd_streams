defmodule ExdStreams.Query.TablePlugin do
  @moduledoc """
  Plugin that joins a stream of data with a persisted materialised view
  """
  use Exd.Plugin
  use GenStage

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
    state = %{}
    do_init(mode, state)
  end
  defp do_init(:source, state),
    do: {:producer, state}
  defp do_init(:sink, state),
    do: {:producer_consumer, state}

  @impl true
  def handle_demand(demand, state) do
    {:noreply, [], state}
  end

  @impl true
  def handle_events(events, state) do
    {:noreply, events, state}
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
