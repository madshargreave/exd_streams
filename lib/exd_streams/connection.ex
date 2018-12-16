defmodule ExdStreams.Connection do
  @moduledoc """
  Public command-based API
  """
  alias ExdStreams.Connection.Sessions.{Supervisor, Session, SessionRegistry}

  @doc """
  Creates a new session
  """
  def connect(role) do
    Supervisor.start_child(role: role)
  end

  @doc """
  Creates a new session
  """
  def close(role) do
    Supervisor.terminate_child(role: role)
  end

  @doc """
  Runs command in the context of role
  """
  def run(role, command) do
    command = Map.put(command, :role, role)
    Session.run(command)
  end

end
