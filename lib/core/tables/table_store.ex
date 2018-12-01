defmodule ExdStreams.Tables.TableStore do
  @moduledoc false
  alias ExdStreams.Tables.Table

  @callback list() :: Table.t
  @callback list(binary) :: Table.t
  @callback get(binary) :: {:ok, Table.t} | {:error, term}
  @callback save(Table.t) :: {:ok, Table.t} | {:error, term}
  @callback delete(binary) :: {:ok, Table.t} | {:error, term}

end
