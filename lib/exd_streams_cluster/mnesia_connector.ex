defmodule ExdStreamsCluster.MnesiaConnector do
  @moduledoc """
  Registers and starts Mnesia
  """
  require Logger
  alias :mnesia, as: Mnesia

  def connect do
    configure_and_start()
    register_tables()
  end

  defp configure_and_start do
    Logger.info "[#{node()}] Creating Mnesia schema"
    Mnesia.create_schema([node()])
    Logger.info "[#{node()}] Starting Mnesia"
    Mnesia.start()
    Logger.info "[#{node()}] Mnesia started"
  end

  defp register_tables do
    :ok =
      case Mnesia.create_table(
        :streams,
        [
          type: :set,
          disc_copies: [node()],
          attributes: [:id, :user_id, :name, :query, :created_at]
        ]
      ) do
        {:atomic, :ok} ->
          Logger.info "[#{node()}] Mnesia table succesfully created"
          :ok
        {:aborted, {:already_exists, _}} ->
          :ok
      end
    Logger.info "[#{node()}] Tables ready"
  end

end
