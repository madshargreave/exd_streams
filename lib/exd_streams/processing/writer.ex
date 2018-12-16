defmodule ExdStreams.Processing.Writer do
  @moduledoc """
  Write buffer for persisting events to materialised store
  """
  use GenBuffer,
    otp_app: :exd_streams,
    interval: 1000,
    limit: 100

  @store Application.get_env(:exd_streams, :material_store_adapter) || ExdStreams.Store.RelationalStore

  @impl true
  def flush(events) do
    IO.inspect "Writing #{length(events)} events"
    records =
      events
      |> Enum.with_index
      |> Enum.map(fn {event, index} -> {"key_#{NaiveDateTime.utc_now}", event} end)

    @store.put_all("records", records)
  end

end
