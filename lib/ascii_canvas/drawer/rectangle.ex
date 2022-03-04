defmodule AsciiCanvas.Drawer.Rectangle do
  @moduledoc """
  This module provides functions to interact with a canvas
  drawing rectangles.
  """

  alias AsciiCanvas.Drawer.Canvas

  @doc """
  Fills a canvas following a command.
  """
  @spec fill_canvas(Canvas.canvas(), map()) :: {:ok, Canvas.canvas()}
  def fill_canvas(canvas, command) do
    [min_x, min_y] = command["coords"]

    max_x = min_x + command["width"]
    max_y = min_y + command["height"]

    fill_pixels = find_fill_pixels(min_y, max_y, min_x, max_x)
    {:ok, canvas} = draw(canvas, fill_pixels, command["fill"])

    outline_pixels = find_outline_pixels(min_y, max_y, min_x, max_x)
    draw(canvas, outline_pixels, command["out"] || command["fill"])
  end

  @doc """
  Find outline pixels of a rectangle.
  """
  @spec find_outline_pixels(integer(), integer(), integer(), integer()) :: list()
  def find_outline_pixels(min_y, max_y, min_x, max_x) do
    top_bottom =
      for row <- [min_y, max_y - 1], col <- min_x..(max_x - 1) do
        {col, row}
      end

    left_right =
      for row <- (min_y + 1)..(max_y - 2), col <- [min_x, max_x - 1] do
        {col, row}
      end

    Enum.reduce(top_bottom, left_right, &[&1 | &2])
  end

  @doc """
  Find fill pixels of a rectangle.
  """
  @spec find_fill_pixels(integer(), integer(), integer(), integer()) :: list()
  def find_fill_pixels(min_y, max_y, min_x, max_x) do
    for row <- (min_y + 1)..(max_y - 2), col <- (min_x + 1)..(max_x - 2) do
      {col, row}
    end
  end

  defp draw(canvas, _, nil) do
    {:ok, canvas}
  end

  defp draw(canvas, pixels, char) do
    filled_canvas =
      Enum.reduce(pixels, canvas, fn coord, canvas ->
        {coord_x, coord_y} = coord

        canvas
        |> insert_coord(coord_x, coord_y, char)
        |> update_max_filled_col(coord_x, coord_y)
      end)

    {:ok, filled_canvas}
  end

  defp insert_coord(canvas, coord_x, coord_y, char) do
    filled_pixels = put_in(canvas.pixels, [Access.key(coord_y, %{}), coord_x], char)
    %{canvas | pixels: filled_pixels}
  end

  defp update_max_filled_col(canvas, coord_x, coord_y) do
    curr_max_filled_col = Map.get(canvas.max_filled_col, coord_y)

    cond do
      is_nil(curr_max_filled_col) or curr_max_filled_col < coord_x ->
        %{canvas | max_filled_col: Map.put(canvas.max_filled_col, coord_y, coord_x)}

      true ->
        canvas
    end
  end
end
