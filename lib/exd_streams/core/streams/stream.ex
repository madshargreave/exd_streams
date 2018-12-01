defmodule ExdStreams.Streams.Stream do
  @moduledoc """
  A stream represents a continous stream of records
  """
  use ExdStreams.Core.Entity

  schema "streams" do
    field :role_id, :integer
    field :name, :string
    field :query, :map
    timestamps()
  end

  def create_changeset(role, attrs) do
    required = ~w(role_id name query)a
    optional = ~w()

    %__MODULE__{}
    |> cast(attrs, optional ++ required)
    |> put_change(:role_id, role.id)
    |> validate_required(required)
  end

end
