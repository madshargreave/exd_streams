defmodule ExdStreams.Core.Repo.Migrations.CreateStreams do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:streams, engine: :set) do
      add :role_id, :integer, null: false
      add :name, :string, null: false
      add :query, :string, null: false
      timestamps()
    end
  end

end
