defmodule AsciiCanvas.SketchTest do
  use AsciiCanvas.DataCase

  alias AsciiCanvas.Sketch

  describe "canvas" do
    alias AsciiCanvas.Sketch.Canvas

    import AsciiCanvas.SketchFixtures

    @invalid_attrs %{max_size_x: nil, max_size_y: nil}

    test "list_canvas/0 returns all canvas" do
      canvas = canvas_fixture()
      assert Sketch.list_canvas() == [canvas]
    end

    test "get_canvas!/1 returns the canvas with given id" do
      canvas = canvas_fixture()
      assert Sketch.get_canvas!(canvas.id) == canvas
    end

    test "create_canvas/1 with valid data creates a canvas" do
      valid_attrs = %{max_size_x: 42, max_size_y: 42}

      assert {:ok, %Canvas{} = canvas} = Sketch.create_canvas(valid_attrs)
      assert canvas.max_size_x == 42
      assert canvas.max_size_y == 42
    end

    test "create_canvas/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sketch.create_canvas(@invalid_attrs)
    end

    test "update_canvas/2 with valid data updates the canvas" do
      canvas = canvas_fixture()
      update_attrs = %{max_size_x: 43, max_size_y: 43}

      assert {:ok, %Canvas{} = canvas} = Sketch.update_canvas(canvas, update_attrs)
      assert canvas.max_size_x == 43
      assert canvas.max_size_y == 43
    end

    test "update_canvas/2 with invalid data returns error changeset" do
      canvas = canvas_fixture()
      assert {:error, %Ecto.Changeset{}} = Sketch.update_canvas(canvas, @invalid_attrs)
      assert canvas == Sketch.get_canvas!(canvas.id)
    end

    test "delete_canvas/1 deletes the canvas" do
      canvas = canvas_fixture()
      assert {:ok, %Canvas{}} = Sketch.delete_canvas(canvas)
      assert_raise Ecto.NoResultsError, fn -> Sketch.get_canvas!(canvas.id) end
    end

    test "change_canvas/1 returns a canvas changeset" do
      canvas = canvas_fixture()
      assert %Ecto.Changeset{} = Sketch.change_canvas(canvas)
    end
  end

  describe "commands" do
    import AsciiCanvas.SketchFixtures

    @invalid_attrs %{command: nil}

    test "create_command/2 with valid data creates a command" do
      {:ok, canvas} = Sketch.create_canvas(%{max_size_x: 42, max_size_y: 42})

      valid_attrs = %{command: %{"type" => "rect"}}

      assert {:ok, command} = Sketch.create_command(canvas.id, valid_attrs)
      assert command.command == valid_attrs.command
    end

    test "create_command/2 returns error when canvas is not found" do
      random_uuid = Ecto.UUID.generate()

      valid_attrs = %{command: %{"type" => "rect"}}

      assert {:error, :not_found} = Sketch.create_command(random_uuid, valid_attrs)
    end

    test "create_command/2 with invalid data returns error changeset" do
      {:ok, canvas} = Sketch.create_canvas(%{max_size_x: 42, max_size_y: 42})

      assert {:error, %Ecto.Changeset{}} = Sketch.create_command(canvas.id, @invalid_attrs)
    end

    test "get_commands/2 returns all commands from a canvas" do
      {:ok, canvas} = Sketch.create_canvas(%{max_size_x: 42, max_size_y: 42})

      valid_attrs = %{command: %{"type" => "rect"}}

      {:ok, command1} = Sketch.create_command(canvas.id, valid_attrs)
      {:ok, command2} = Sketch.create_command(canvas.id, valid_attrs)

      {:ok, commands} = Sketch.get_commands(canvas.id)

      assert commands == [command1, command2]
    end

    test "get_commands/2 returns query error when invalid input is given" do
      assert {:error, :query_error} = Sketch.get_commands("invalid input")
    end

    test "get_commands/2 returns not found error when invalid canvas_id is given" do
      random_uuid = Ecto.UUID.generate()

      assert {:error, :not_found} = Sketch.get_commands(random_uuid)
    end
  end
end
