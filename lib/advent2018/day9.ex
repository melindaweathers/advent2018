defmodule Day9 do

  def high_score(players, max) do
    _high_score(players, max, 1, [0], 0, 1, %{})
      |> Enum.map(fn {_index, value} -> value end)
      |> Enum.max
  end
  defp _high_score(_, max_num, next_num, _, _, _, scores) when next_num > max_num, do: scores
  defp _high_score(players, max_num, next_num, marbles, current_marble_idx, count, scores) when rem(next_num, 23) == 0 do
    #IO.inspect([marbles, current_marble_idx])
    current_player = rem(next_num, players)
    current_player_score = Map.get(scores, current_player, 0)
    remove_marble_idx = rem(current_marble_idx - 7 + count, count)
    {removed_marble_val, new_marbles} = List.pop_at(marbles, remove_marble_idx)
    new_scores = Map.put(scores, current_player, current_player_score + removed_marble_val + next_num)
    new_current_marble = rem(remove_marble_idx, count - 1)
    #IO.inspect(new_marbles)
    #IO.inspect([remove_marble_idx, marbles_count, new_current_marble])
    _high_score(players, max_num, next_num + 1, new_marbles, new_current_marble, count - 1, new_scores)
  end
  defp _high_score(players, max_num, next_num, marbles, current_marble_idx, count, scores) do
    #IO.inspect([marbles, current_marble_idx])
    new_index = rem(current_marble_idx + 2, count)
    new_marbles = List.insert_at(marbles, new_index, next_num)
    _high_score(players, max_num, next_num + 1, new_marbles, new_index, count + 1, scores)
  end

  def run do
    IO.inspect(high_score(5, 25), label: "Should be 32")
    IO.inspect(high_score(10, 1618), label: "Should be 8317")
    IO.inspect(high_score(13, 7999), label: "Should be 146373")
    IO.inspect(high_score(17, 1104), label: "Should be 2764")
    IO.inspect(high_score(21, 6111), label: "Should be 54718")
    IO.inspect(high_score(30, 5807), label: "Should be 37305")
    IO.inspect(high_score(403, 71920), label: "First Star Answer")
    IO.inspect(high_score(403, 7192000), label: "Second Star Answer")
  end
end
