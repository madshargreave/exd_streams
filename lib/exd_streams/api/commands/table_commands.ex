alias ExdStreams.Tables
alias ExdStreams.Api.{Executable, Commands}

defimpl Executable, for: Commands.CreateTableCommand do
  def execute(command) do
    attrs = Map.take(command, [:config, :name, :query])
    Tables.create_table(command.role, attrs)
  end
end

defimpl Executable, for: Commands.CreateTableWithAliasCommand do
  def execute(command) do
    attrs = Map.take(command, [:config, :name, :query])
    Tables.create_table_with_query(command.role, attrs)
  end
end

defimpl Executable, for: Commands.DropTableCommand do
  def execute(command) do
    Tables.delete_table(command.role, command.name)
  end
end
