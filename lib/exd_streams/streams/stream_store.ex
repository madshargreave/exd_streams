defmodule ExdStreams.Streams.StreamStore do
  @moduledoc false
  alias ExdStreams.Stream

  @callback list() :: Stream.t
  @callback list(binary) :: Stream.t
  @callback get() :: {:ok, Stream.t} | {:error, term}
  @callback save() :: {:ok, Stream.t} | {:error, term}
  @callback drop() :: {:ok, Stream.t} | {:error, term}

end
