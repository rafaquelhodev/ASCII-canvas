defmodule AsciiCanvasWeb.PageController do
  use AsciiCanvasWeb, :controller

  alias AsciiCanvas.Drawing

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def draw_canvas(conn, params) do
    case Drawing.draw_canvas(params["id"]) do
      {:ok, drawing} ->
        render(conn, "draw.html", drawing: drawing)

      {:error, reason} ->
        conn
        |> put_flash(:info, reason)
        |> redirect(to: "/")
    end
  end
end
