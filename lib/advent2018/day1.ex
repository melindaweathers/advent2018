#mix run -e 'Day2.run'
defmodule Day1 do
  def find_repeated(list), do: _find_repeated(list, list, 0, %{})

  # For when we need to loop back around because the list is empty
  defp _find_repeated(orig_list, [], total, previous_totals) do
    _find_repeated(orig_list, orig_list, total, previous_totals)
  end

  # For when the list is not empty
  defp _find_repeated(orig_list, [head|tail], total, previous_totals) do
    new_total = head + total
    if Map.has_key?(previous_totals, new_total) do
      new_total
    else
      _find_repeated(orig_list, tail, new_total, Map.put_new(previous_totals, total, true))
    end
  end

  def run do
    IO.puts "Hello world"

    words = File.stream!("inputs/day1.txt") |> Stream.map(&String.trim_trailing/1) |> Enum.to_list
    nums = Enum.map(words, fn word -> String.to_integer(word) end)

    IO.puts "SUM:"
    IO.puts Enum.sum(nums)

    IO.puts "Should be 0:"
    IO.puts find_repeated([1, -1])

    IO.puts "Should be 10:"
    IO.puts find_repeated([3, 3, 4, -2, -4])

    IO.puts "Should be 5:"
    IO.puts find_repeated([-6, 3, 8, 5, -6])

    IO.puts "Should be 14:"
    IO.puts find_repeated([7, 7, -2, -7, -4])

    IO.puts "Final Result:"
    IO.puts find_repeated(nums)
  end
end
