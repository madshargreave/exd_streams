defmodule ExdStreams.Core.Repo do
  @moduledoc """
  Repository for core entities
  """
  use Ecto.Repo, otp_app: :exd_streams

  def child_spec(opts \\ []) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

end
