defmodule AsciiCanvasWeb.CanvasController do
  use AsciiCanvasWeb, :controller

  alias AsciiCanvas.Sketch
  alias AsciiCanvas.Drawing

  def create(conn, canvas = %{}) do
    with {:ok, canvas} <- Sketch.create_canvas(canvas) do
      render(conn, "create_canvas.json", canvas: canvas)
    end
  end

  def add_command(conn, params) do
    with {:ok, command} <- Sketch.create_command(params["id"], conn.body_params) do
      render(conn, "add_command.json", command: command)
    end
  end

  def draw(conn, params) do
    with {:ok, drawing} <- Drawing.draw_canvas(params["id"]) do
      render(conn, "drawing.json", drawing: drawing)
    end
  end
end
