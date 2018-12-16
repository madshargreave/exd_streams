alias Exd.AST
alias ExdStreams.Streams
alias ExdStreams.Api.{Executable, Commands}
alias ExdStreams.Query.TablePlugin

defimpl Executable, for: Commands.SelectCommand do
  def execute(command) do
    attrs = Map.take(command, [:config, :query])
    spec = {TablePlugin, [mode: :sink, meta: command.meta]}
    select = %AST.SelectExpr{command.query.query.select | into: spec}
    query = %AST.Query{command.query.query | select: select}
    Exd.Repo.all(query)
  end
end
