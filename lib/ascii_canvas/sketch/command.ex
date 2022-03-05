defmodule AsciiCanvas.Sketch.Command do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "commands" do
    field :command, :map
    belongs_to :canvas, AsciiCanvas.Sketch.Canvas

    timestamps()
  end

  @doc false
  def changeset(command, attrs) do
    command
    |> cast(attrs, [:command, :canvas_id])
    |> validate_required([:command, :canvas_id])
  end
end
