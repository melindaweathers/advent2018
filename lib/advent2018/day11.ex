defmodule Day11 do
  @size 300
  def get_power_level(x,y,serial) do
    rack_id = x + 10
    power_level = rack_id*(rack_id * y + serial)
    hundreds = Integer.to_string(power_level) |> String.at(-3) |> String.to_integer()
    hundreds - 5
  end

  def build_grid(serial) do
    Enum.map(1..@size, fn(x) ->
      ys = Enum.map(1..@size, fn(y) ->
        {y, get_power_level(x,y,serial)}
      end)
      { x, Map.new(ys) }
    end) |> Map.new
  end

  def print_grid(grid) do
    Enum.map(1..@size, fn(x) ->
      ys = Enum.map(1..@size, fn(y) ->
        val_or_zero(grid, x, y)
      end)
      IO.inspect(ys)
    end)
  end

  def largest_square(serial, size) do
    grid = build_grid(serial)
    _largest_square(grid, size, 1, 1, {0, 0, 0})
  end
  defp _largest_square(_, size, x, y, {largest_x, largest_y, largest_val}) when x == @size - size and y == @size - size, do: {largest_x, largest_y, largest_val}
  defp _largest_square(grid, size, x, y, result) when x == @size - size, do: _largest_square(grid, size, 1, y+1, result)
  defp _largest_square(grid, size, x, y, {largest_x, largest_y, largest_val}) do
    val = square_val(grid, size, x, y)
    if val > largest_val do
      _largest_square(grid, size, x+1, y, {x, y, val})
    else
      _largest_square(grid, size, x+1, y, {largest_x, largest_y, largest_val})
    end
  end

  def next_size(grid, orig_grid, size) do
    Enum.map(1..@size-size+1, fn(x) ->
      ys = Enum.map(1..@size-size+1, fn(y) ->
        {y, hollow_square_val(grid,orig_grid,size,x,y)}
      end)
      { x, Map.new(ys) }
    end) |> Map.new
  end

  defp largest_cell(_, size, x, y, {largest_x, largest_y, largest_val}) when x == @size - size and y == @size - size, do: {largest_x, largest_y, largest_val}
  defp largest_cell(grid, size, x, y, result) when x == @size - size, do: largest_cell(grid, size, 1, y+1, result)
  defp largest_cell(grid, size, x, y, {largest_x, largest_y, largest_val}) do
    val = grid[x][y]
    if val > largest_val do
      largest_cell(grid, size, x+1, y, {x, y, val})
    else
      largest_cell(grid, size, x+1, y, {largest_x, largest_y, largest_val})
    end
  end

  def largest_square_any_size(serial) do
    grid = build_grid(serial)
    _largest_square_any_size(grid, grid, 1, {0,0,0,0})
  end
  defp _largest_square_any_size(_, _, @size, {largest_x, largest_y, _, largest_size}), do: {largest_x, largest_y, largest_size}
  defp _largest_square_any_size(grid, orig_grid, size, {largest_x, largest_y, largest_val, largest_size}) do
    #{x, y, val} = largest_cell(grid, size, 1, 1, {0, 0, 0})
    {x, y, val} = largest_cell(grid, size, 1, 1, {0, 0, 0})
    #print_grid(grid)
    #IO.inspect("Trying size #{size}, best was #{x}, #{y}, #{val}]}")
    next_grid = next_size(grid, orig_grid, size+1)
    if val > largest_val do
      _largest_square_any_size(next_grid, orig_grid, size + 1, {x, y, val, size})
    else
      if val == 0 do
        {largest_x, largest_y, largest_size}
      else
        _largest_square_any_size(next_grid, orig_grid, size + 1, {largest_x, largest_y, largest_val, largest_size})
      end
    end
  end

  def square_val(grid, size, x, y) do
    Enum.map(x..x+size-1, fn(x) ->
      Enum.map(y..y+size-1, fn(y) ->
        grid[x][y]
      end)
    end) |> List.flatten() |> Enum.sum()
  end

  def val_or_zero(grid, x, y) do
    row = Map.get(grid, x, %{y => 0})
    Map.get(row, y, 0)
  end

  def hollow_square_val(grid, orig_grid, size, x, y) do
    xmax = x+size-1
    ymax = y+size-1
    horiz = Enum.map(x..xmax, fn(x) -> val_or_zero(orig_grid, x, ymax) end)
    vert = Enum.map(y..ymax-1, fn(y) -> val_or_zero(orig_grid, xmax, y) end)
    Enum.sum(vert) + Enum.sum(horiz) + grid[x][y]
  end

  def run do
    IO.inspect(get_power_level(3,5,8), label: "Should be 4")
    IO.inspect(get_power_level(122,79,57), label: "Should be -5")
    IO.inspect(get_power_level(217,196,39), label: "Should be 0")
    IO.inspect(get_power_level(101,153,71), label: "Should be 4")

    IO.inspect(largest_square(18, 3), label: "Should be 33,45")
    IO.inspect(largest_square(42, 3), label: "Should be 21,61")
    IO.inspect(largest_square(9005, 3), label: "First star")

    IO.inspect(largest_square_any_size(18), label: "Should be 90,269,16")
    IO.inspect(largest_square_any_size(42), label: "Should be 232,251,12")
    IO.inspect(largest_square_any_size(9005), label: "Second Star")
  end
end
