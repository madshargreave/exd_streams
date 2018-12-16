defmodule ExdStreams.Connection.Sessions.Session do
  @moduledoc """
  An authenticated session
  """
  use GenServer

  alias ExdStreams.Connection.Sessions.SessionRegistry
  alias ExdStreams.Api.Executable

  defstruct [:role, :started_at]

  ## Client

  @doc """
  Starts session

  ## Options

    * `role` - The role of the caller
  """
  def start_link(opts \\ []) do
    role = Keyword.fetch!(opts, :role)
    GenServer.start_link(__MODULE__, opts, name: via(role))
  end

  @doc """
  Runs the given command
  """
  def run(command) do
    GenServer.call(via(command.role), {:run, command})
  end

  @doc """
  Terminates the session
  """
  def close(role) do
    GenServer.call(via(role), :close)
  end

  ## Server

  @impl true
  def init(opts) do
    role = Keyword.fetch!(opts, :role)
    started_at = NaiveDateTime.utc_now
    state = %__MODULE__{role: role, started_at: started_at}
    {:ok, state}
  end

  @impl true
  def handle_call({:run, command}, _from, state) do
    command_with_role = Map.put(command, :role, state.role)
    result = spawn fn -> Executable.execute(command_with_role) end
    {:reply, :ok, state}
  end

  @impl true
  def handle_call(:close, _from, state) do
    {:stop, :normal, state}
  end

  defp via(role) do
    {:via, Registry, {SessionRegistry, role}}
  end

end
