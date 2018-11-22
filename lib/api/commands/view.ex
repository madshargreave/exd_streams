defmodule ExdStreams.Commands.View do
  @moduledoc false

  defmodule CreateViewCommand do
    @moduledoc false
    defstruct [:config, :name, :query]
  end

  defmodule DropViewCommand do
    @moduledoc false
    defstruct [:name]
  end

end
