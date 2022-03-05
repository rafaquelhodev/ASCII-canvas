defmodule AsciiCanvasWeb.CanvasControllerTest do
  use AsciiCanvasWeb.ConnCase

  alias AsciiCanvas.Sketch

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create new canvas" do
    test "with valid parameters", %{conn: conn} do
      params = %{
        "max_size_x" => 14,
        "max_size_y" => 8
      }

      conn = post(conn, Routes.canvas_path(conn, :create, params))

      [canvas] = Sketch.list_canvas()

      assert json_response(conn, 200) == %{
               "id" => canvas.id,
               "max_size_x" => 14,
               "max_size_y" => 8
             }
    end
  end

  describe "add new commands to canvas" do
    test "with valid parameters", %{conn: conn} do
      params = %{
        "max_size_x" => 14,
        "max_size_y" => 8
      }

      {:ok, canvas} = Sketch.create_canvas(params)

      command1 = %{
        "type" => "rect",
        "coords" => [14, 0],
        "height" => 6,
        "width" => 7,
        "out" => nil,
        "fill" => "."
      }

      conn =
        post(conn, Routes.canvas_path(conn, :add_command, canvas.id), %{"command" => command1})

      {:ok, [command]} = Sketch.get_commands(canvas.id)

      assert json_response(conn, 200) == %{
               "id" => command.id,
               "command" => command1
             }
    end
  end

  describe "get drawing string from canvas" do
    test "when canvas has overlaping", %{conn: conn} do
      params = %{
        "max_size_x" => 14,
        "max_size_y" => 8
      }

      {:ok, canvas} = Sketch.create_canvas(params)

      command1 = %{
        "type" => "rect",
        "coords" => [14, 0],
        "height" => 6,
        "width" => 7,
        "out" => nil,
        "fill" => "."
      }

      command2 = %{
        "type" => "rect",
        "coords" => [0, 3],
        "height" => 4,
        "width" => 8,
        "out" => "O",
        "fill" => nil
      }

      command3 = %{
        "type" => "rect",
        "coords" => [5, 5],
        "height" => 3,
        "width" => 5,
        "out" => "X",
        "fill" => "X"
      }

      post(conn, Routes.canvas_path(conn, :add_command, canvas.id), %{"command" => command1})
      post(conn, Routes.canvas_path(conn, :add_command, canvas.id), %{"command" => command2})
      post(conn, Routes.canvas_path(conn, :add_command, canvas.id), %{"command" => command3})

      conn = get(conn, Routes.canvas_path(conn, :draw, canvas.id))

      expected_draw =
        "              .......\n              .......\n              ......." <>
          "\nOOOOOOOO      .......\nO      O      ......." <>
          "\nO    XXXXX    .......\nOOOOOXXXXX" <>
          "\n     XXXXX"

      assert json_response(conn, 200) == %{
               "drawing" => expected_draw
             }
    end
  end
end
