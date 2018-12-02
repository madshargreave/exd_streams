defmodule ExdStreams.Roles.Store.MnesiaImpl do
  @moduledoc false
  import Ecto.Query

  alias ExdStreams.Roles.Role
  alias ExdStreams.Core.Repo

  @behaviour ExdStreams.Roles.RoleStore

  @impl true
  def list do
    Repo.all(Role)
  end

  @impl true
  def list(role_id) do
    Repo.all(
      from s in Role,
      where: s.owner_id == ^role_id
    )
  end

  @impl true
  def get(role_id) do
    Repo.get(Role, role_id)
  end

  @impl true
  def save(changeset) do
    Repo.insert_or_update(changeset)
  end

  @impl true
  def save!(changeset) do
    Repo.insert_or_update!(changeset)
  end

  @impl true
  def delete(role) do
    Repo.delete(role)
  end

end
