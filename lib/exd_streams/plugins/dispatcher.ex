defmodule ExdStreams.Plugins.Dispatcher do
  @moduledoc false
  use GenDispatcher, otp_app: :exd_streams

  def dispatch(event) do
    dispatch("event:core", event)
  end

end
