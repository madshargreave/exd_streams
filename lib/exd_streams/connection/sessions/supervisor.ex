defmodule ExdStreams.Connection.Sessions.Supervisor do
  @moduledoc false
  use DynamicSupervisor

  alias ExdStreams.Connection.Sessions.Session
  alias ExdStreams.Connection.Sessions.SessionRegistry

  def start_link(init_args \\ []) do
    DynamicSupervisor.start_link(__MODULE__, init_args, name: __MODULE__)
  end

  def start_child(child_args \\ []) do
    role = Keyword.fetch(child_args, :role)
    child_spec = %{
      id: {Session, role},
      start: {Session, :start_link, [child_args]},
      # restart: :temporary
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def terminate_child([role: role]) do
    [{pid, _}] = Registry.lookup(SessionRegistry, role)
    DynamicSupervisor.terminate_child(__MODULE__, pid)
  end

  def init(init_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

end
