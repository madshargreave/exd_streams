defmodule ExdStreams.Store.ElasticStore do
  @moduledoc """
  An ElasticSearch based store
  """
  use ExdStreams.Store.IndexStore

  alias ExdStreams.Store, as: BaseStore
  alias ExdStreams.Store.{KeyValueStore, IndexStore}

  defstruct [:index]

  @impl BaseStore
  def init(opts) do
    index = Keyword.fetch!(opts, :index)
    state = %{index: index}
    {:ok, state}
  end

  @impl BaseStore
  def name do
    :elastic_store
  end

  @impl KeyValueStore
  def all(state) do
    perform_search(
      state.index,
      %{
        "query" => %{
          "match_all" => %{}
        }
      }
    )
  end

  @impl KeyValueStore
  def get(key, state) do
    perform_search(
      state.index,
      %{
        "query" => %{
          "term" => %{
            "id" => key
          }
        }
      }
    )
  end

  @impl KeyValueStore
  def put(key, value, state) do

  end

  @impl KeyValueStore
  def put_all(keys_and_values, state) do

  end

  @impl KeyValueStore
  def delete(key, state) do

  end

  @impl IndexStore
  def search(query, state) do

  end

  defp perform_search(index, query) do
    Elasticsearch.post(ExdStreams.ElasticsearchCluster, "/#{index}/_doc/_search", query)
  end

end
