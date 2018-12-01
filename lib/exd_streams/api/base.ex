defmodule ExdStreams.Api.BaseCommand do
  @moduledoc """
  Protocol for executable commands
  """

  @doc false
  defmacro defcommand(module, fields) do
    fields = [:role] ++ fields
    quote do
      defmodule unquote(module) do
        @moduledoc false
        defstruct unquote(fields)
      end
    end
  end

end
