defmodule ExdStreams.Store.RelationalStore do
  @moduledoc """
  A Mnesia based state store
  """
  import Ecto.Query
  use ExdStreams.Store.KeyValueStore

  alias ExdStreams.Store.BaseStore
  alias ExdStreams.Store.KeyValueStore

  defmodule RecordRepo do
    use Ecto.Repo,
      otp_app: :exd_streams
  end

  defmodule Record do
    use Ecto.Schema

    @primary_key {:key, :string, autogenerate: false}
    @foreign_key_type :string

    schema "records" do
      field :table_id, :string
      field :value, :map
      field :state, :string
      field :ts, :naive_datetime
    end

  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  @impl true
  def init(_) do
    {:ok, nil}
  end

  @impl BaseStore
  def name do
    :relational_store
  end

  @impl KeyValueStore
  def all(table_id) do
    RecordRepo.all(
      from r in Record,
      where: r.table_id == ^table_id,
      order_by: [desc: r.key]
    )
  end

  @impl KeyValueStore
  def get(table_id, key) do
    RecordRepo.one(
      from r in Record,
      where: r.table_id == ^table_id and r.key == ^key
    )
  end

  @impl KeyValueStore
  def put(table_id, key, value) do
    row = [key: key, value: value]
    opts = [on_conflict: :replace_all, conflict_target: [:key]]
    RecordRepo.insert_all(Record, [row], opts)
  end

  @impl KeyValueStore
  def put_all(rows) do
    opts = [on_conflict: :replace_all, conflict_target: [:key]]
    RecordRepo.insert_all(Record, rows, opts)
  end

  @impl KeyValueStore
  def delete(key, state) do
    raise "delete/2 not implemented"
  end

  defp convert(records) do
    records
  end

end
