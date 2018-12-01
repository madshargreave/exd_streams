defprotocol ExdStreams.Api.Executable do
  @moduledoc """
  Dynamic dispatch for commands
  """
  def execute(command)
end
