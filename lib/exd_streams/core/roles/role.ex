defmodule ExdStreams.Roles.Role do
  @moduledoc """
  A role
  """
  use ExdStreams.Core.Entity

  schema "roles" do
    field :owner_id, :string
    field :name, :string
    field :admin, :boolean, default: false
    timestamps()
  end

  def create_admin_changeset(role, attrs) do
    create_user_changeset(role, attrs)
    |> put_change(:admin, true)
  end

  def create_user_changeset(role, attrs) do
    required = ~w(role_id name)a
    optional = ~w()

    %__MODULE__{}
    |> cast(attrs, optional ++ required)
    |> put_change(:owner_id, role.id)
    |> validate_required(required)
  end

end
