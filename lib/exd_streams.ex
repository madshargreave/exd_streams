defmodule ExdStreams do
  @moduledoc """
  ExdStreams provides a high-level and declarative interface for defining
  topologies of streams
  """
  alias ExdStreams.Connection

  @doc """
  Creates a new session based on role
  """
  def connect(role) do
    Connection.connect(role)
  end

  @doc """
  Runs command in current session
  """
  def run(session, command) do
    Connection.run(session, command)
  end

  @doc """
  Closes session
  """
  def close(session) do
    Connection.close(session)
  end

end
