defmodule AsciiCanvas.Drawer.Canvas do
  defstruct size: {nil, nil}, pixels: %{}, max_filled_col: %{}

  def create(max_x, max_y) do
    cond do
      is_integer(max_x) and is_integer(max_y) and max_x > 0 and max_y > 0 ->
        {:ok, %__MODULE__{size: {max_x, max_y}}}

      true ->
        {:error, "invalid parameters"}
    end
  end
end
