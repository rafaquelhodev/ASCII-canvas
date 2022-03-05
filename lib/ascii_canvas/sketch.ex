defmodule AsciiCanvas.Sketch do
  @moduledoc """
  The Sketch context.
  """

  import Ecto.Query, warn: false
  alias AsciiCanvas.Repo

  alias AsciiCanvas.Sketch.Canvas

  @doc """
  Returns the list of canvas.

  ## Examples

      iex> list_canvas()
      [%Canvas{}, ...]

  """
  def list_canvas do
    Repo.all(Canvas)
  end

  @doc """
  Gets a single canvas.

  Raises `Ecto.NoResultsError` if the Canvas does not exist.

  ## Examples

      iex> get_canvas!(123)
      %Canvas{}

      iex> get_canvas!(456)
      ** (Ecto.NoResultsError)

  """
  def get_canvas!(id), do: Repo.get!(Canvas, id)

  @doc """
  Gets a single canvas.

  Returns {:error, :not_found} if the Canvas does not exist.

  ## Examples

      iex> get_canvas!(123)
      {:ok, %Canvas{}}

      iex> get_canvas!(456)
      {:error, :not_found}

  """
  def get_canvas(id) do
    case Repo.get(Canvas, id) do
      nil -> {:error, :not_found}
      canvas -> {:ok, canvas}
    end
  end

  @doc """
  Creates a canvas.

  ## Examples

      iex> create_canvas(%{field: value})
      {:ok, %Canvas{}}

      iex> create_canvas(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_canvas(attrs \\ %{}) do
    %Canvas{}
    |> Canvas.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a canvas.

  ## Examples

      iex> update_canvas(canvas, %{field: new_value})
      {:ok, %Canvas{}}

      iex> update_canvas(canvas, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_canvas(%Canvas{} = canvas, attrs) do
    canvas
    |> Canvas.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a canvas.

  ## Examples

      iex> delete_canvas(canvas)
      {:ok, %Canvas{}}

      iex> delete_canvas(canvas)
      {:error, %Ecto.Changeset{}}

  """
  def delete_canvas(%Canvas{} = canvas) do
    Repo.delete(canvas)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking canvas changes.

  ## Examples

      iex> change_canvas(canvas)
      %Ecto.Changeset{data: %Canvas{}}

  """
  def change_canvas(%Canvas{} = canvas, attrs \\ %{}) do
    Canvas.changeset(canvas, attrs)
  end

  alias AsciiCanvas.Sketch.Command

  @doc """
  Creates a command for a given canvas_id.

  ## Examples

      iex> create_command("982bd991-80ed-4008-9607-6db8f222d9e8", %{field: value})
      {:ok, %Command{}}

  """
  def create_command(canvas_id, attrs \\ %{}) do
    with {:ok, canvas} <- get_canvas(canvas_id) do
      command_with_canvas = Map.put(attrs, :canvas_id, canvas.id)

      %Command{}
      |> Command.changeset(command_with_canvas)
      |> Repo.insert()
    end
  end

  @doc """
  Gets all commands for a given canvas_id.

  Returns `{:ok, results}` in case of success.

  Returns `{:error, :not_found}` if the given canvas id not found.
  If and error occurs during the operation, returns `{:error, :query_error}`.

  ## Examples

    iex> get_commands("982bd991-80ed-4008-9607-6db8f222d9e8")
    {:ok, [%Command{}]}

    iex> get_commands("invalid_input")
    {:error, :query_error}

  """
  def get_commands(canvas_id) do
    try do
      query =
        from c in Command,
          where: c.canvas_id == ^canvas_id,
          order_by: c.inserted_at,
          select: c

      case Repo.all(query) do
        [] -> {:error, :not_found}
        [_ | _] = resp -> {:ok, resp}
      end
    rescue
      _ -> {:error, :query_error}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking command changes.

  ## Examples

      iex> change_command(command)
      %Ecto.Changeset{data: %Command{}}

  """
  def change_command(%Command{} = command, attrs \\ %{}) do
    Command.changeset(command, attrs)
  end
end
