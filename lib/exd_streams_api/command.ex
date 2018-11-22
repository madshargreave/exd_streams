defprotocol ExdStreams.Command do
  @moduledoc """
  Protocol for executable commands
  """

  @doc """
  Executes dommand
  """
  def execute(command)

end
