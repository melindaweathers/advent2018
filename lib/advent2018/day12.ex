defmodule Day12 do
  @padding 4000
  def read_lines(filename) do
    File.stream!(filename)
      |> Stream.map( &( parse_line(&1) ) )
      |> Map.new
  end
  def parse_line(line) do
    [pattern, "=>", result] = String.split(line)
    {pattern, result}
  end

  def state_sum(state), do: _state_sum(state, -1*@padding, 0)
  defp _state_sum([], _, sum), do: sum
  defp _state_sum(["#"|tail], offset, sum), do: _state_sum(tail, offset + 1, sum + offset)
  defp _state_sum(["."|tail], offset, sum), do: _state_sum(tail, offset + 1, sum)

  def grow(state, patterns, days) do
    padding = String.duplicate(".", @padding)
    [padding, state, padding]
      |> Enum.join()
      |> String.graphemes()
      |> _grow(patterns, days, days)
  end
  defp _grow(state, _, 0, _), do: state |> state_sum
  defp _grow(state, patterns, days, total_days) do
    new_state = grow_day(state, patterns)
    change = state_sum(new_state) - state_sum(state)
    #IO.inspect("Day #{days}, sum is #{state_sum(new_state)}, diff is #{state_sum(new_state) - state_sum(state)}")
    if change == 36 do #:shiba: Saw this repeating in the log
      state_sum(new_state) + (36 * (days - 1))
    else
      _grow(new_state, patterns, days - 1, total_days)
    end
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
