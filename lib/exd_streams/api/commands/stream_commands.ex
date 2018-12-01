alias ExdStreams.Streams
alias ExdStreams.Api.{Executable, Commands}

defimpl Executable, for: Commands.CreateStreamCommand do
  def execute(command) do
    attrs = Map.take(command, [:config, :name, :query])
    Streams.create_stream(command.role, attrs)
  end
end

defimpl Executable, for: Commands.DropStreamCommand do
  def execute(command) do
    Streams.delete_stream(command.role, command.name)
  end
end
