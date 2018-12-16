defmodule Day12 do
  def read_lines(filename) do
    File.stream!(filename)
      |> Stream.map( &( parse_line(&1) ) )
      |> Map.new
  end
  def parse_line(line) do
    [pattern, "=>", result] = String.split(line)
    {pattern, result}
  end

  def state_sum(state, offset), do: _state_sum(state, offset, 0)
  defp _state_sum([], _, sum), do: sum
  defp _state_sum(["#"|tail], offset, sum), do: _state_sum(tail, offset + 1, sum + offset)
  defp _state_sum(["."|tail], offset, sum), do: _state_sum(tail, offset + 1, sum)

  def grow(state, patterns, days) do
    padding = "...................."
    [padding, state, padding]
      |> Enum.join()
      |> String.graphemes()
      |> _grow(patterns, days)
      |> state_sum(-20)
  end
  defp _grow(state, _, 0), do: state
  defp _grow(state, patterns, days) do
    _grow(grow_day(state, patterns), patterns, days - 1)
  end

  def grow_day(state, patterns) do
    result = _grow_day([".","."|state] ++ [".","."], patterns, [])
    #IO.inspect(result |> Enum.join())
    result
  end
  defp _grow_day([one,two,three,four,five|tail], patterns, result) do
    new_result = Map.get(patterns, Enum.join([one,two,three,four,five]), ".")
    _grow_day([two,three,four,five|tail], patterns, [new_result|result])
  end
  defp _grow_day(_, _, result) do
    result |> Enum.reverse()
  end

  def run do
    initial_state_sample = "#..#.#..##......###...###"
    patterns_sample = read_lines("inputs/day12-sample.txt")
    IO.inspect(grow(initial_state_sample, patterns_sample, 20), label: "Sample - should be 325")

    initial_state = "#..####.##..#.##.#..#.....##..#.###.#..###....##.##.#.#....#.##.####.#..##.###.#.......#............"
    patterns = read_lines("inputs/day12.txt")
    IO.inspect(grow(initial_state, patterns, 20), label: "First Star")

    IO.inspect(grow(initial_state, patterns, 50000000000), label: "Second Star")
  end
end
