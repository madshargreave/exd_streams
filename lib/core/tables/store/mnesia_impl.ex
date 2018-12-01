defmodule ExdStreams.Tables.Store.MnesiaImpl do
  @moduledoc false
  import Ecto.Query

  alias ExdStreams.Tables.Table
  alias ExdStreams.Core.Repo

  @behaviour ExdStreams.Tables.TableStore

  @impl true
  def list do
    Repo.all(Stream)
  end

  @impl true
  def list(role_id) do
    Repo.all(
      from s in Stream,
      where: s.role_id == ^role_id
    )
  end

  @impl true
  def get(stream_id) do
    Repo.get(Stream, stream_id)
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
  def delete(stream) do
    Repo.delete(stream)
  end

end
