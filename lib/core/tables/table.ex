defmodule ExdStreams.Tables.Table do
  @moduledoc """
  A view represents a snapshots of the latest stream of records for a particular stream
  """
  use ExdStreams.Core.Entity

  schema "tables" do
    field :role_id, :integer
    field :name, :string
    field :query, :map
    timestamps()
  end

  def create_changeset(role, attrs) do
    required = ~w(role_id name)a
    optional = ~w()

    %__MODULE__{}
    |> cast(attrs, optional ++ required)
    |> put_change(:role_id, role.id)
    |> validate_required(required)
  end

  def create_with_query_changeset(role, attrs) do
    required = ~w(role_id name query)a
    optional = ~w()

    %__MODULE__{}
    |> cast(attrs, optional ++ required)
    |> put_change(:role_id, role.id)
    |> validate_required(required)
  end

end
