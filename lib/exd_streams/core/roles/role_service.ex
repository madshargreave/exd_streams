defmodule ExdStreams.Roles.RoleService do
  @moduledoc """
  Roles service
  """
  alias ExdStreams.Core.Dispatcher
  alias ExdStreams.Roles.Store.MnesiaImpl, as: DefaultStore
  alias ExdStreams.Roles.Role

  @store Application.get_env(:exd_streams, :role_store_impl) || DefaultStore

  @doc """
  List all user streams
  """
  def list(%{system: true} = role), do: @store.list()
  def list(role) do
    @store.list(role.id)
  end

  @doc """
  Return a single role
  """
  def get(role, role_id) do
    @store.get(role_id)
  end

  @doc """
  Create and register a new role with query
  """
  def create_admin(role, attrs \\ %{}) do
    changeset = Role.create_admin_changeset(role, attrs)
    role = @store.save!(changeset)
    Dispatcher.dispatch({:created, role})
    role
  end

  @doc """
  Create and register a new role
  """
  def create_user(role, attrs \\ %{}) do
    changeset = Role.create_user_changeset(role, attrs)
    role = @store.save!(changeset)
    Dispatcher.dispatch({:created, role})
    role
  end

  @doc """
  Drops an existing role
  """
  def drop(role, name) do
    role = get(role, name)
    @store.delete(role)
    Dispatcher.dispatch({:dropped, role})
    role
  end

end
