defmodule ExdStreams.Connection.Sessions.Supervisor do
  @moduledoc false
  use DynamicSupervisor
  alias ExdStreams.Connection.Session

  def start_link(init_args \\ []) do
    DynamicSupervisor.start_link(__MODULE__, init_args, name: __MODULE__)
  end

  def start_child(child_args \\ []) do
    role = Keyword.fetch(child_args, :role)
    child_spec = %{
      id: {Session, role},
      start: {Session, :start_link, [child_args]},
      restart: :transient
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def init(init_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

end
