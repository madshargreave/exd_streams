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
      field :table, :string
      field :value, :map
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
  def all(table) do
    RecordRepo.all(
      from r in Record,
      where: r.table == ^table
    )
  end

  @impl KeyValueStore
  def get(table, key) do
    RecordRepo.one(
      from r in Record,
      where: r.table == ^table and r.key == ^key
    )
  end

  @impl KeyValueStore
  def put(table, key, value) do
    row = [table: table, key: key, value: value]
    opts = [on_conflict: :replace_all, conflict_target: [:table, :key]]
    RecordRepo.insert_all(Record, [row], opts)
  end

  @impl KeyValueStore
  def put_all(rows) do
    opts = [on_conflict: :replace_all, conflict_target: [:table, :key]]
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
