defmodule AsciiCanvas.Drawer.RectangleTest do
  use ExUnit.Case, async: true

  alias AsciiCanvas.Drawer.Rectangle

  test "find outline pixels of a rectangle" do
    got_outline_pixels = Rectangle.find_outline_pixels(2, 5, 2, 6)

    expected_outline_pixels = [
      {2, 2},
      {2, 3},
      {2, 4},
      {5, 2},
      {5, 3},
      {5, 4},
      {3, 2},
      {4, 2},
      {3, 4},
      {4, 4}
    ]

    assert Enum.sort(got_outline_pixels) == Enum.sort(expected_outline_pixels)
  end

  test "find fill pixels of a rectangle" do
    got_outline_pixels = Rectangle.find_fill_pixels(2, 5, 2, 6)

    expected_outline_pixels = [
      {3, 3},
      {4, 3}
    ]

    assert Enum.sort(got_outline_pixels) == Enum.sort(expected_outline_pixels)
  end
end
