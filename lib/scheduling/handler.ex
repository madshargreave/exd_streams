defmodule ExdStreams.Scheduling.Handler do
  @moduledoc false
  # use ExdStreams.Consumer
  alias ExdStreams.Tables.Table
  alias ExdStreams.Scheduling

  @impl true
  def handle({:created, %Table{} = table}) do
    Scheduling.schedule(table.query)
  end

end
