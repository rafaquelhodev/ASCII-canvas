defmodule AsciiCanvas.Repo.Migrations.CreateCommands do
  use Ecto.Migration

  def change do
    create table(:commands, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :command, :map
      add :canvas_id, references(:canvas, type: :uuid)

      timestamps()
    end
  end
end
