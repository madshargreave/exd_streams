defmodule ExdStreams.Streams do
  @moduledoc """
  The queries context.
  """
  alias ExdStreams.Streams.{
    StreamService
  }

  defdelegate list_streams(role), to: StreamService, as: :list
  defdelegate get_stream!(id), to: StreamService, as: :get!
  defdelegate create_stream(role, attrs), to: StreamService, as: :create
  defdelegate delete_stream(role, id), to: StreamService, as: :delete

end

