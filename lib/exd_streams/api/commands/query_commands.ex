alias Exd.AST
alias ExdStreams.Streams
alias ExdStreams.Api.{Executable, Commands}
alias ExdStreams.Query.{FilePlugin, TablePlugin}

defimpl Executable, for: Commands.SelectCommand do
  def execute(%Commands.SelectCommand{
    query: %AST.Program{
      insert: nil,
      query: %AST.Query{} = query
    } = program
  } = command) do
    spec = {TablePlugin, []}
    select = %AST.SelectExpr{command.query.query.select | into: spec}
    query = %AST.Query{command.query.query | select: select}
    program = %AST.Program{program | query: query}

    meta = Keyword.merge([table: command.table], Map.to_list(command.meta))
    Exd.Repo.all(program, meta)
  end
  def execute(%Commands.SelectCommand{
    table: name,
    query: %AST.Program{
      insert: %AST.InsertExpr{
        into: %AST.TableIdentifier{
          # value: name
        }
      },
      query: %AST.Query{} = query
    } = program
  } = command) do
    spec = {TablePlugin, []}
    select = %AST.SelectExpr{command.query.query.select | into: spec}
    query = %AST.Query{command.query.query | select: select}
    program = %AST.Program{program | query: query}

    meta = Keyword.merge([table: name], Map.to_list(command.meta))
    Exd.Repo.all(program, meta)
  end
  def execute(%Commands.SelectCommand{
    table: name,
    query: %AST.Program{
      insert: %AST.InsertExpr{
        into: %AST.CallExpr{
          identifier: %AST.Identifier{value: "file"},
          params: [
            %AST.StringLiteral{
              value: file_name
            }
          ]
        }
      },
      query: %AST.Query{} = query
    } = program
  } = command) do

    spec = {FilePlugin, []}
    select = %AST.SelectExpr{command.query.query.select | into: spec}
    query = %AST.Query{command.query.query | select: select}
    program = %AST.Program{program | query: query}

    meta = Keyword.merge([table: name, file_name: file_name], Map.to_list(command.meta))
    Exd.Repo.all(program, meta)
  end
end
