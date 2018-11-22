defmodule ExdStreams.Commands.PrintCommand do
  @moduledoc """
  A command that will create a new stream

  ## Data

    * `target` - The target stream
    * `query` - The query definition
  """
  alias ExdStreams.Streams

  defstruct [:stream]

  defimpl ExdStreams.Command do
    def execute(command) do
      attrs = %{query: command.query}
      Streams.create_stream(attrs)
    end
  end

end
