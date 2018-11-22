defmodule ExdStreams.Api.Commands.Stream do
  @moduledoc false
  import ExdStreams.Api.Command
  alias ExdStreams.Api.Executable
  alias ExdStreams.Streams

  defcommand CreateStreamCommand, [:config, :name, :query]
  defcommand DropStreamCommand, [:name]

  defimpl Executable, for: CreateStreamCommand do
    def execute(command) do
      attrs = Map.take(command, [:config, :name, :query])
      Streams.create_stream(command.role, attrs)
    end
  end

  defimpl Executable, for: DropStreamCommand do
    def execute(command) do
      Streams.delete_stream(command.role, command.name)
    end
  end

end
