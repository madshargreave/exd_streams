defmodule ExdStreams.Streams.Stream do
  @moduledoc """
  A stream represents a continous stream of records
  """

  defstruct [
    :id,
    :user_id,
    :name,
    :query,
    :created_at
  ]

  @type t :: %__MODULE__{}

  def make(attrs \\ %{}) do
    # id = UUID.uuid4()
    created_at = NaiveDateTime.utc_now()
    attrs = Map.merge(attrs, %{created_at: created_at})
    struct(__MODULE__, attrs)
  end

end
