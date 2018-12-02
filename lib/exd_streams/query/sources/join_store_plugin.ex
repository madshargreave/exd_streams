defmodule ExdStreams.Exd.Plugins.JoinStorePlugin do
  @moduledoc """
  Plugin that joins a stream of data with a persisted materialised view
  """
  use Exd.Plugin
  use GenStage

  @store Application.get_env(:exd_streams, :exd_join_store)

  defstruct [
    :left_key,
    :right_key,
    :binding
  ]

  @doc """
  Starts plugin

  ## Options

    * `left_key` - The key to join with
    * `right_key` - The remote key to join with
    * `binding` - The binding of the join
  """
  def start_link(opts \\ []) do
    GenStage.start_link(__MODULE__, opts)
  end

  @impl true
  def init([mode: :join]) do
    state = %{}
    {:ok, :producer_consumer}
  end

  @impl true
  def handle_events(records, state) do
    left = Enum.map(records, &Kernel.get_in(&1, state.left_key))
    results = for key <- left, do: @store.get(key)
    produced = Record.zip(state.binding, records, results)
    {:noreply, produced, state}
  end

end
