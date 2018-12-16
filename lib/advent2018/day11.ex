defmodule Day11 do
  def get_power_level(x,y,serial) do
    rack_id = x + 10
    power_level = rack_id*(rack_id * y + serial)
    hundreds = Integer.to_string(power_level) |> String.at(-3) |> String.to_integer()
    hundreds - 5
  end

  def build_grid(serial) do
    Enum.map(1..300, fn(x) ->
      ys = Enum.map(1..300, fn(y) ->
        {y, get_power_level(x,y,serial)}
      end)
      { x, Map.new(ys) }
    end) |> Map.new
  end

  def largest_square(serial, size) do
    grid = build_grid(serial)
    _largest_square(grid, size, 1, 1, {0, 0, 0})
  end
  defp _largest_square(_, size, x, y, {largest_x, largest_y, largest_val}) when x == 300 - size and y == 300 - size, do: {largest_x, largest_y, largest_val}
  defp _largest_square(grid, size, x, y, result) when x == 300 - size, do: _largest_square(grid, size, 1, y+1, result)
  defp _largest_square(grid, size, x, y, {largest_x, largest_y, largest_val}) do
    val = square_val(grid, size, x, y)
    if val > largest_val do
      _largest_square(grid, size, x+1, y, {x, y, val})
    else
      _largest_square(grid, size, x+1, y, {largest_x, largest_y, largest_val})
    end
  end

  def largest_square_any_size(serial), do: _largest_square_any_size(build_grid(serial), 1, {0,0,0,0})
  defp _largest_square_any_size(_, 300, {largest_x, largest_y, _, largest_size}), do: {largest_x, largest_y, largest_size}
  defp _largest_square_any_size(grid, size, {largest_x, largest_y, largest_val, largest_size}) do
    IO.inspect("Trying size #{size}")
    {x, y, val} = _largest_square(grid, size, 1, 1, {0, 0, 0})
    if val > largest_val do
      _largest_square_any_size(grid, size + 1, {x, y, val, size})
    else
      _largest_square_any_size(grid, size + 1, {largest_x, largest_y, largest_val, largest_size})
    end
  end

  def square_val(grid, size, x, y) do
    Enum.map(x..x+size-1, fn(x) ->
      Enum.map(y..y+size-1, fn(y) ->
        grid[x][y]
      end)
    end) |> List.flatten() |> Enum.sum()
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
  end
end
