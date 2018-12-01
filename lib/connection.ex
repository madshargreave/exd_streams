defmodule ExdStreams.Connection do
  @moduledoc """
  Public command-based API
  """
  alias ExdStreams.Connection.{SessionSupervisor, Session}

  @doc """
  Creates a new session
  """
  def connect(role) do
    SessionSupervisor.start_child(role: role)
  end

  @doc """
  Creates a new session
  """
  def close(role) do
    Session.close(role)
  end

  @doc """
  Runs command in the context of role
  """
  def run(role, command) do
    command = Map.put(command, :role, role)
    Session.run(command)
  end

end
