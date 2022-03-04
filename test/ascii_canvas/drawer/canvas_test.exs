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
end
