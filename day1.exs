IO.puts "Hello world"

words = File.stream!("inputs/day1.txt") |> Stream.map(&String.trim_trailing/1) |> Enum.to_list
nums = Enum.map(words, fn word -> String.to_integer(word) end)

IO.puts "SUM:"
IO.puts Enum.sum(nums)

defmodule NumSums do
  def find_repeated(list), do: _find_repeated(list, list, 0, [])

  # For when we need to loop back around because the list is empty
  defp _find_repeated(orig_list, [], total, previous_totals) do
    _find_repeated(orig_list, orig_list, total, previous_totals)
  end

  # For when the list is not empty
  defp _find_repeated(orig_list, [head|tail], total, previous_totals) do
    new_total = head + total
    if new_total in previous_totals do
      new_total
    else
      _find_repeated(orig_list, tail, new_total, [total|previous_totals])
    end
  end
end

IO.puts "Should be 0:"
IO.puts NumSums.find_repeated([1, -1])

IO.puts "Should be 10:"
IO.puts NumSums.find_repeated([3, 3, 4, -2, -4])

IO.puts "Should be 5:"
IO.puts NumSums.find_repeated([-6, 3, 8, 5, -6])

IO.puts "Should be 14:"
IO.puts NumSums.find_repeated([7, 7, -2, -7, -4])

IO.puts "Final Result:"
IO.puts NumSums.find_repeated(nums)
