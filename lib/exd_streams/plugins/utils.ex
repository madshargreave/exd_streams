defmodule ExdStreams.Plugins.Utils do
  @moduledoc """
  Utils
  """

  def hash_state(state) when is_binary(state) do
    :crypto.hash(:md5, state) |> Base.encode16(case: :lower)
  end

end
