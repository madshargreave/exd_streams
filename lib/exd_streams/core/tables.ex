defmodule ExdStreams.Tables do
  @moduledoc """
  The queries context.
  """
  alias ExdStreams.Tables.{
    Table,
    TableService
  }

  defdelegate list_tables(role, pagination), to: TableService, as: :list
  defdelegate get_table!(role, id), to: TableService, as: :get!
  defdelegate create_table(role, attrs), to: TableService, as: :create
  defdelegate delete_table(role, attrs), to: TableService, as: :delete

end

