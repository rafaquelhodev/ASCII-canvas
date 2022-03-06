defmodule AsciiCanvasWeb.PageControllerTest do
  use AsciiCanvasWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "ASCII Canvas"
  end
end
