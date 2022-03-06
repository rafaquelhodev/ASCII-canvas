defmodule AsciiCanvas.Sketch.Command do
  use Ecto.Schema
  import Ecto.Changeset

  alias AsciiCanvas.Drawer

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "commands" do
    field :command, :map
    belongs_to :canvas, AsciiCanvas.Sketch.Canvas

    timestamps()
  end

  @doc false
  def changeset(command, attrs, canvas_dimensions) do
    command
    |> cast(attrs, [:command, :canvas_id])
    |> validate_required([:command, :canvas_id])
    |> validate_geometry(Map.get(attrs, "command") || Map.get(attrs, :command), canvas_dimensions)
  end

  defp validate_geometry(changeset, command = %{"type" => "rect"}, canvas_dimensions) do
    validate_rectangle(changeset, command, canvas_dimensions)
  end

  defp validate_geometry(changeset, command = %{type: "rect"}, canvas_dimensions) do
    validate_rectangle(changeset, command, canvas_dimensions)
  end

  defp validate_geometry(changeset, _, _) when changeset.valid? do
    add_error(changeset, :command, "invalid geometry type")
  end

  defp validate_geometry(changeset, _, _) when not changeset.valid? do
    changeset
  end

  defp validate_rectangle(changeset, command, canvas_dimensions) do
    case changeset.valid? do
      true ->
        rect_changeset = Drawer.Rectangle.validate(command, canvas_dimensions)

        changeset
        |> Map.put(:errors, rect_changeset.errors)
        |> Map.put(:valid?, rect_changeset.valid?)

      _ ->
        changeset
    end
  end
end
