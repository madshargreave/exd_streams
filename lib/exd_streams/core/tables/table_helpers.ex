defmodule ExdStreams.Tables.TableHelpers do
  @moduledoc """
  Common helpers for tables
  """

  @doc """
  Check if has one or more indices defined
  """
  def indexed?(table) do
    table.indices > 0
  end

end
