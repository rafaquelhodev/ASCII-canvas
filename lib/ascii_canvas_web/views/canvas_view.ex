defmodule AsciiCanvasWeb.CanvasView do
  use AsciiCanvasWeb, :view

  def render("create_canvas.json", %{canvas: canvas}) do
    %{id: canvas.id, max_size_x: canvas.max_size_x, max_size_y: canvas.max_size_y}
  end

  def render("add_command.json", %{command: command}) do
    %{
      id: command.id,
      command: command.command
    }
  end

  def render("drawing.json", %{drawing: drawing}) do
    %{drawing: drawing}
  end
end
