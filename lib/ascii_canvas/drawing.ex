defmodule AsciiCanvas.Drawing do
  alias AsciiCanvas.Sketch

  alias AsciiCanvas.Drawer

  def draw_canvas(canvas_id) do
    with {:ok, canvas} <- Sketch.get_canvas_and_commands(canvas_id),
         {:ok, drawing_canvas} <- Drawer.Canvas.create(canvas.max_size_x, canvas.max_size_y),
         draw_commands <- Enum.map(canvas.commands, &Map.get(&1, :command)),
         {:ok, drawing_canvas} <- Drawer.Canvas.fill_pixels(drawing_canvas, draw_commands) do
      {:ok, Drawer.Canvas.generate_draw(drawing_canvas)}
    end
  end
end
