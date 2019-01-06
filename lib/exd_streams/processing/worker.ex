defmodule ExdStreams.Processing.Worker do
  @moduledoc """
  Wraps a supervised Exd query
  """
  require Logger
  use GenServer
  alias ExdStreams.StreamRegistry

  defstruct [
    :id,
    :status,
    :user_id,
    :query,
    :coordinator,
    :started_at
  ]

  # Client

  @doc """
  Starts stream under distributed supervisor and registry
  """
  def start_link(stream) do
    GenServer.start_link(__MODULE__, stream, name: via(stream.id))
  end

  @doc """
  Drops the stream
  """
  def drop(id) do
    GenServer.call(via(id), :drop)
  end

  @doc """
  Returns the current status of the stream
  """
  def status(id) do
    GenServer.call(via(id), :status)
  end

  # Server

  @impl true
  def init(stream) do
    Logger.info "Starting stream on node: #{Node.self()}"
    # query = configure_query(stream)
    # {:ok, pid} = Exd.Repo.start_link(query)
    # state =
    #   %__MODULE__{
    #     id: stream.id,
    #     query: query,
    #     coordinator: pid,
    #     status: :running,
    #     started_at: NaiveDateTime.utc_now
    #   }
    {:ok, %{}}
    rescue
      exception ->
        IO.inspect {exception, System.stacktrace()}
  end

  @impl true
  def handle_call(:drop, _, state) do
    {:stop, :normal, state}
  end

  @impl true
  def handle_call(:status, _, state) do
    result = state
    {:reply, state, state}
  end

  defp via(id) do
    {:via, Horde.Registry, {StreamRegistry, id}}
  end

end
