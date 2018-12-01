defmodule ExdStreams.Cluster.Connector do
  @moduledoc """
  Behaviour for cluster connectors
  """

  @doc """
  Schedule processes on a node in cluster
  """
  @callback connect() :: :ok | {:error, term}

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour ExdStreams.Cluster.Connector
    end
  end

end
