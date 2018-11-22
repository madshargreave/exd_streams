defmodule ExdStreams.Commands.CreateStreamCommand do
  @moduledoc """
  A command that will create a new stream

  ## Data

    * `target` - The target stream
    * `query` - The query definition
  """
  alias ExdStreams.Streams

  defstruct [
    :config,
    :name,
    :query
  ]

  defimpl ExdStreams.Command do
    def execute(command) do
      attrs = %{query: command.query}
      Streams.create_stream(attrs)
    end
  end

end
