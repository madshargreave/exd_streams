defmodule ExdStreams.Tables.TableService do
  @moduledoc """
  Tables service
  """
  alias ExdStreams.Core.Dispatcher
  alias ExdStreams.Tables.Store.MnesiaImpl, as: DefaultStore
  alias ExdStreams.Tables.Table

  @store Application.get_env(:exd_streams, :table_store_impl) || DefaultStore

  @doc """
  List all user streams
  """
  def list(%{system: true} = role), do: @store.list()
  def list(role) do
    @store.list(role.id)
  end

  @doc """
  Return a single table
  """
  def get(role, table_id) do
    @store.get(table_id)
  end

  @doc """
  Create and register a new table
  """
  def create(role, attrs \\ %{}) do
    changeset = Table.create_changeset(role, attrs)
    table = @store.save!(changeset)
    Dispatcher.dispatch({:created, table})
    table
  end

  @doc """
  Create and register a new table with query
  """
  def create_with_query(role, attrs \\ %{}) do
    changeset = Table.create_with_query_changeset(role, attrs)
    table = @store.save!(changeset)
    Dispatcher.dispatch({:created, table})
    table
  end

  @doc """
  Drops an existing table
  """
  def drop(role, name) do
    table = get(role, name)
    @store.delete(table)
    Dispatcher.dispatch({:dropped, table})
    table
  end

end
