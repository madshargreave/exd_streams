defmodule ExdStreams.Plugins.StreamPlugin.RedisPool do
  @moduledoc """
  Manages a pool of redix connections
  """
  @pool_size 5

  def child_spec(_args) do
    %{
      id: RedixSupervisor,
      type: :supervisor,
      start: {Supervisor, :start_link, [children(), [strategy: :one_for_one]]}
    }
  end

  defp children do
    for index <- 0..(@pool_size - 1) do
      spec = {Redix, name: :"redix_#{index}"}
      Supervisor.child_spec(spec, id: {Redix, index})
    end
  end

  @doc """
  Dispatch command using a pooled Redix connection
  """
  def command(command) do
    Redix.command(:"redix_#{random_index()}", command)
  end

  @doc """
  Dispatch a pipeline of commands using a pooled Redix connection
  """
  def pipeline(commands) do
    Redix.pipeline(:"redix_#{random_index()}", commands)
  end

  defp random_index do
    rem(System.unique_integer([:positive]), @pool_size)
  end

end
