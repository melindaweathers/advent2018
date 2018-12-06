defmodule Day5 do
  def load_polymer(filename) do
    File.read!(filename) |> String.trim_trailing |> String.graphemes
  end

  def capital?(char) do
    String.capitalize(char) == char
  end
  def opposite?(char1, char2) do
    String.capitalize(char1) == String.capitalize(char2) && ((capital?(char1) && !capital?(char2)) || (!capital?(char1) && capital?(char2)))
  end

  def reduce_polymer(polymer), do: _reduce_polymer(polymer, [], :none_found, "NA")
  defp _reduce_polymer([], reduced, :none_found, "NA"), do: reduced |> Enum.reverse() |> Enum.join()
  defp _reduce_polymer([], reduced, :reduced, "NA"), do: _reduce_polymer(reduced |> Enum.reverse(), [], :none_found, "NA")
  defp _reduce_polymer([], reduced, status, prev_char), do: _reduce_polymer([], [prev_char|reduced], status, "NA")
  defp _reduce_polymer([head|tail], reduced, status, "NA"), do: _reduce_polymer(tail, reduced, status, head)
  defp _reduce_polymer([head|tail], reduced, status, prev_char) do
    if opposite?(prev_char, head) do
      if List.first(reduced) do
        [headreduced | tailreduced] = reduced
        _reduce_polymer(tail, tailreduced, :reduced, headreduced)
      else
        _reduce_polymer(tail, reduced, :reduced, "NA")
      end
    else
      _reduce_polymer(tail, [prev_char|reduced], status, head)
    end
  end

  def run do
    sample_polymer = load_polymer("inputs/day5-sample.txt")
    IO.inspect(String.length(reduce_polymer(sample_polymer)), label: "Sample reduced length")

    polymer = load_polymer("inputs/day5.txt")
    IO.inspect(String.length(reduce_polymer(polymer)), label: "First star length")
  end
end
