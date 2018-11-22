defmodule ExdStreams.Streams.StreamStore do
  @moduledoc false
  alias ExdStreams.Streams.Stream

  @callback list() :: Stream.t
  @callback list(binary) :: Stream.t
  @callback get(binary) :: {:ok, Stream.t} | {:error, term}
  @callback save(Stream.t) :: {:ok, Stream.t} | {:error, term}
  @callback delete(binary) :: {:ok, Stream.t} | {:error, term}

end
