defmodule ExdStreams.Roles do
  @moduledoc """
  The queries context.
  """
  alias ExdStreams.Roles.{
    RoleService
  }

  defdelegate list_roles(role), to: RoleService, as: :list
  defdelegate get_role!(id), to: RoleService, as: :get!
  defdelegate create_user_role(role, attrs), to: RoleService, as: :create_user
  defdelegate create_admin_role(role, id), to: RoleService, as: :create_admin
  defdelegate delete_role(role, id), to: RoleService, as: :delete

end

