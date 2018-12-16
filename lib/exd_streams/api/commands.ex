defmodule ExdStreams.Api.Commands do
  @moduledoc false
  import ExdStreams.Api.BaseCommand

  # Queries
  defcommand SelectCommand, [:meta, :config, :query]

  # Streams
  defcommand CreateStreamCommand, [:config, :name, :query]
  defcommand DropStreamCommand, [:name]

  # Tables
  defcommand CreateTableCommand, [:config, :name]
  defcommand CreateTableWithAliasCommand, [:config, :name, :query]
  defcommand DropTableCommand, [:name]

end
