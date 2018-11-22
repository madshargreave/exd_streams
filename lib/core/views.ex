defmodule ExdStreams.Views do
  @moduledoc """
  The queries context.
  """
  alias ExdStreams.Views.{
    ViewService
  }

  defdelegate list_views(user, pagination), to: ViewService, as: :list
  defdelegate get_view!(user, id), to: ViewService, as: :get!
  defdelegate create_view(user, attrs), to: ViewService, as: :create
  defdelegate delete_view(user, attrs), to: ViewService, as: :delete

end

