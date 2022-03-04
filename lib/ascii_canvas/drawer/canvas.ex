defmodule AsciiCanvas.Drawer.Canvas do
  @moduledoc """
  This module keeps the logics to create a canvas and draw on it.
  """

  alias AsciiCanvas.Drawer.Rectangle

  defstruct size: {nil, nil}, pixels: %{}, max_filled_col: %{}

  @type canvas :: %__MODULE__{
          size: tuple(),
          pixels: map(),
          max_filled_col: map()
        }

  @doc """
  Creates a canvas with empty pixels.
  """
  @spec create(canvas(), integer()) :: {:ok, canvas()} | {:error, binary()}
  def create(max_x, max_y) do
    cond do
      is_integer(max_x) and is_integer(max_y) and max_x > 0 and max_y > 0 ->
        {:ok, %__MODULE__{size: {max_x, max_y}}}

      true ->
        {:error, "invalid parameters"}
    end
  end

  @doc """
  Generates a draw for the given canvas.
  """
  @spec generate_draw(canvas) :: binary()
  def generate_draw(canvas) do
    {_, size_y} = canvas.size

    Enum.reduce(0..(size_y - 1), "", fn row, acc ->
      max_col = Map.get(canvas.max_filled_col, row)

      acc <> get_row_representation(canvas, {row, max_col}) <> "\n"
    end)
    |> String.trim_trailing()
  end

  @doc """
  Fill pixels in a canvas according to provided commands.any()

  Return `{:ok, canvas}` in case of success. If an error occurs, returns
  `{:error, reason}`.
  """
  @spec fill_pixels(canvas(), list()) :: {:ok, canvas()} | {:error, binary()}
  def fill_pixels(canvas, commands) do
    Enum.reduce_while(commands, {:ok, canvas}, fn command, acc ->
      {:ok, curr_canvas} = acc

      case fill_pixels_with_geometry(curr_canvas, command) do
        {:ok, _} = resp -> {:cont, resp}
        {:error, _} = err -> {:halt, err}
      end
    end)
  end

  defp get_row_representation(canvas, {row, col}) when is_nil(col) == false do
    Enum.reduce(0..col, "", fn col_i, acc ->
      get_in(canvas.pixels, [row, col_i])
      |> char_representation()
      |> (&(&2 <> &1)).(acc)
    end)
  end

  defp get_row_representation(_, {_, nil}) do
    ""
  end

  defp char_representation(char) do
    cond do
      is_binary(char) -> char
      true -> " "
    end
  end

  defp fill_pixels_with_geometry(canvas, command = %{"type" => "rect"}) do
    Rectangle.fill_canvas(canvas, command)
  end

  defp fill_pixels_with_geometry(_, _) do
    {:error, "invalid geometry type"}
  end
end
