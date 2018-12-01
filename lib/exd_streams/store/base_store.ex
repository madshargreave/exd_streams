defmodule ExdStreams.Store.BaseStore do
  @moduledoc """
  A behaviour for any state store
  """

  @doc """
  Initialises the state store
  """
  @callback init(context :: map) :: :ok | {:error, term}

  @doc """
  Name of state store
  """
  @callback name() :: binary

end
