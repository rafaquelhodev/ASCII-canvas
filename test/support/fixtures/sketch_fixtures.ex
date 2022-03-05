defmodule AsciiCanvas.SketchFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AsciiCanvas.Sketch` context.
  """

  @doc """
  Generate a canvas.
  """
  def canvas_fixture(attrs \\ %{}) do
    {:ok, canvas} =
      attrs
      |> Enum.into(%{
        max_size_x: 42,
        max_size_y: 42
      })
      |> AsciiCanvas.Sketch.create_canvas()

    canvas
  end

  @doc """
  Generate a command.
  """
  def command_fixture(attrs \\ %{}) do
    {:ok, command} =
      attrs
      |> Enum.into(%{
        command: %{}
      })
      |> AsciiCanvas.Sketch.create_command()

    command
  end
end
