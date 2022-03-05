defmodule AsciiCanvas.Repo.Migrations.CreateCanvas do
  use Ecto.Migration

  def change do
    create table(:canvas, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :max_size_x, :integer
      add :max_size_y, :integer

      timestamps()
    end
  end
end
