defmodule AsciiCanvas.Drawer.CanvasTest do
  use ExUnit.Case, async: true

  alias AsciiCanvas.Drawer.Canvas

  test "create canvas with success" do
    assert {:ok, _} = Canvas.create(10, 20)
  end

  test "create canvas with invalid parameters" do
    assert {:error, _} = Canvas.create(-10, 20)
    assert {:error, _} = Canvas.create(10, -20)
    assert {:error, _} = Canvas.create(-10, -20)
    assert {:error, _} = Canvas.create(0, 20)
    assert {:error, _} = Canvas.create(10, 0)
  end

  test "fill pixels with rectangle" do
    {:ok, canvas} = Canvas.create(10, 10)

    commands = [
      %{
        "type" => "rect",
        "coords" => [0, 0],
        "height" => 3,
        "width" => 3,
        "out" => "X",
        "fill" => "."
      }
    ]

    assert {:ok, canvas} = Canvas.fill_pixels(canvas, commands)

    pixels = canvas.pixels

    assert get_in(pixels, [0, 0]) == "X"
    assert get_in(pixels, [1, 0]) == "X"
    assert get_in(pixels, [2, 0]) == "X"
    assert get_in(pixels, [1, 2]) == "X"
    assert get_in(pixels, [2, 2]) == "X"
    assert get_in(pixels, [0, 1]) == "X"
    assert get_in(pixels, [2, 1]) == "X"
    assert get_in(pixels, [1, 1]) == "."
  end

  test "fill pixels with invalid geometry" do
    {:ok, canvas} = Canvas.create(10, 10)

    commands = [
      %{
        "type" => "invalid_geometry",
        "coords" => [0, 0],
        "height" => 3,
        "width" => 3,
        "out" => "X",
        "fill" => "."
      }
    ]

    assert {:error, _} = Canvas.fill_pixels(canvas, commands)
  end

  test "generate draw with two rectangles" do
    {:ok, canvas} = Canvas.create(14, 9)

    commands = [
      %{
        "type" => "rect",
        "coords" => [3, 2],
        "height" => 3,
        "width" => 5,
        "out" => "@",
        "fill" => "X"
      },
      %{
        "type" => "rect",
        "coords" => [10, 3],
        "height" => 6,
        "width" => 14,
        "out" => "X",
        "fill" => "O"
      }
    ]

    assert {:ok, canvas} = Canvas.fill_pixels(canvas, commands)

    got_draw = Canvas.generate_draw(canvas)

    expected_draw =
      "\n\n   @@@@@\n   @XXX@  XXXXXXXXXXXXXX" <>
        "\n   @@@@@  XOOOOOOOOOOOOX\n          XOOOOOOOOOOOOX" <>
        "\n          XOOOOOOOOOOOOX\n          XOOOOOOOOOOOOX" <>
        "\n          XXXXXXXXXXXXXX"

    assert got_draw == expected_draw
  end

  test "generate draw with overlaping rectangles" do
    {:ok, canvas} = Canvas.create(14, 8)

    commands = [
      %{
        "type" => "rect",
        "coords" => [14, 0],
        "height" => 6,
        "width" => 7,
        "out" => nil,
        "fill" => "."
      },
      %{
        "type" => "rect",
        "coords" => [0, 3],
        "height" => 4,
        "width" => 8,
        "out" => "O",
        "fill" => nil
      },
      %{
        "type" => "rect",
        "coords" => [5, 5],
        "height" => 3,
        "width" => 5,
        "out" => "X",
        "fill" => "X"
      }
    ]

    assert {:ok, canvas} = Canvas.fill_pixels(canvas, commands)

    got_draw = Canvas.generate_draw(canvas)

    expected_draw =
      "              .......\n              .......\n              ......." <>
        "\nOOOOOOOO      .......\nO      O      ......." <>
        "\nO    XXXXX    .......\nOOOOOXXXXX" <>
        "\n     XXXXX"

    assert got_draw == expected_draw
  end
end
