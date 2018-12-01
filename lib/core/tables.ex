defmodule ExdStreams.Tables do
  @moduledoc """
  The queries context.
  """
  alias ExdStreams.Tables.{
    TableService
  }

  defdelegate list_views(user, pagination), to: TableService, as: :list
  defdelegate get_view!(user, id), to: TableService, as: :get!
  defdelegate create_view(user, attrs), to: TableService, as: :create
  defdelegate delete_view(user, attrs), to: TableService, as: :delete

end

