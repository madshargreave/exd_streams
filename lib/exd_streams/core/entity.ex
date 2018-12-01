defmodule ExdStreams.Core.Entity do
  @moduledoc """
  Base entity for entities
  """

  @doc false
  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      @before_compile ExdStreams.Core.Entity
    end
  end

  @doc false
  defmacro __before_compile__(_env) do
    quote do
      @type t :: %__MODULE__{}
    end
  end

end
