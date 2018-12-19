defmodule ExdStreams.EventHandler do
  @moduledoc """
  Receives events
  """
  use GenServer

  ## Client

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  ## Server

  @impl true
  def init do
    {:ok, nil}
  end

end
