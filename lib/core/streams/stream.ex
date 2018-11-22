defmodule ExdStreams.Streams.Stream do
  @moduledoc """
  A stream represents a continous stream of records
  """

  defstruct [
    :id,
    :role_id,
    :name,
    :query,
    :created_at
  ]

  @type t :: %__MODULE__{}

  def make(role, attrs \\ %{}) do
    # id = UUID.uuid4()
    created_at = NaiveDateTime.utc_now()
    attrs = Map.merge(attrs, %{role_id: role, created_at: created_at})
    struct(__MODULE__, attrs)
  end

end
