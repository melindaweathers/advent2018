defmodule Day10 do
  def read_lines(filename) do
    File.stream!(filename)
      |> Stream.map( &( parse_line(&1) ) )
      |> Enum.to_list
  end
  def parse_line(line) do
    ["position=", xpos, ypos, " velocity=", xvel, yvel, _] = String.split(line, ["<",">",","])
    [xpos, ypos, xvel, yvel]
      |> Enum.map(&( &1 |> String.trim() |> String.to_integer))
      |> List.to_tuple()
  end

  def is_star?([], _, _), do: false
  def is_star?([{x,y,_,_} | _], x, y), do: true
  def is_star?([_ | tail], x, y), do: is_star?(tail, x, y)

  def xs(stars) do
    xvals = stars |> Enum.map(fn {x,_,_,_} -> x end)
    [Enum.min(xvals), Enum.max(xvals)]
  end
  def ys(stars) do
    yvals = stars |> Enum.map(fn {_,y,_,_} -> y end)
    [Enum.min(yvals), Enum.max(yvals)]
  end
  def print_grid(stars) do
    [min_x, max_x] = xs(stars)
    [min_y, max_y] = ys(stars)
    Enum.map(min_y..max_y, fn(y) ->
      row = Enum.map(min_x..max_x, fn(x) ->
        if is_star?(stars, x, y), do: '#', else: '.'
      end)
      IO.puts(Enum.join(row))
    end)
  end

  def move(stars), do: _move(stars, [])
  defp _move([], moved), do: moved
  defp _move([{x,y,xvel,yvel}|tail], moved), do: _move(tail, [{x+xvel,y+yvel,xvel,yvel}|moved])

  def play_forever(stars) do
    print_grid(stars)
    IO.gets "Next?\n"
    play_forever(move(stars))
  end

  def star_range(stars) do
    [min_x, max_x] = xs(stars)
    [min_y, max_y] = ys(stars)
    [max_x - min_x, max_y - min_y]
  end

  def run_until_expansion(stars) do
    [xrange, yrange] = star_range(stars)
    _run_until_expansion(stars, xrange, yrange, 0)
  end
  defp _run_until_expansion(stars, xrange, yrange, seconds) do
    new_stars = move(stars)
    [new_xrange, new_yrange] = star_range(new_stars)
    if xrange < new_xrange || yrange < new_yrange do
      [stars, seconds]
    else
      _run_until_expansion(new_stars, new_xrange, new_yrange, seconds + 1)
    end
  end

  def run do
    sample_stars = read_lines("inputs/day10-sample.txt")
    [sample_message, sample_seconds] = run_until_expansion(sample_stars)
    print_grid(sample_message)
    IO.inspect("It toook #{sample_seconds} seconds")

    stars = read_lines("inputs/day10.txt")
    [message, seconds] = run_until_expansion(stars)
    print_grid(message)
    IO.inspect("It toook #{seconds} seconds")
  end
end
