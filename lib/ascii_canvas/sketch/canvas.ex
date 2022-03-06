defmodule AsciiCanvas.Sketch.Canvas do
  use Ecto.Schema
  import Ecto.Changeset

  alias AsciiCanvas.Drawer

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "canvas" do
    field :max_size_x, :integer
    field :max_size_y, :integer
    has_many :commands, AsciiCanvas.Sketch.Command

    timestamps()
  end

  @doc false
  def changeset(canvas, attrs) do
    canvas
    |> cast(attrs, [:max_size_x, :max_size_y])
    |> validate_required([:max_size_x, :max_size_y])
    |> validate_dimensions(:max_size_x)
    |> validate_dimensions(:max_size_y)
  end

  defp validate_dimensions(changeset, field) do
    case changeset.valid? do
      true ->
        case Drawer.Canvas.validate_dimensions(Map.get(changeset.changes, field)) do
          {:ok} -> changeset
          {:error, reason} -> add_error(changeset, field, reason)
        end

      _ ->
        changeset
    end
  end
end
