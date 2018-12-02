defmodule ExdStreams.Roles.RoleStore do
  @moduledoc false
  alias ExdStreams.Roles.Role

  @callback list() :: Role.t
  @callback list(binary) :: Role.t
  @callback get(binary) :: {:ok, Role.t} | {:error, term}
  @callback save(Role.t) :: {:ok, Role.t} | {:error, term}
  @callback delete(binary) :: {:ok, Role.t} | {:error, term}

end
