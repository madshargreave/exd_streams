defmodule ExdStreams.Store do
  @moduledoc """
  Store implementation
  """

  @doc false
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do

      # {otp_app, adapter} = ExdStreams.Store.Config.compile_config(__MODULE__, opts)
      # @otp_app otp_app
      # @adapter adapter

      # def __adapter__ do
      #   @adapter
      # end

      # def start_link(opts \\ []) do
      #   __adapter__().start_link(opts)
      # end

      # def put(key, value) do
      #   __adapter__().put(key, value)
      # end

      # def put_all(keys_and_values) do
      #   __adapter__().put_all(keys_and_values)
      # end

    end
  end

end
