defmodule Day9 do

  def high_score(players, max) do
    _high_score(players, max, 9, [8,0], [4,2,5,1,6,3,7], %{})
      |> Enum.map(fn {_index, value} -> value end)
      |> Enum.max
  end
  defp _high_score(_, max_num, next_num, _, _, scores) when next_num > max_num, do: scores
  defp _high_score(players, max_num, next_num, left, [], scores) do
    #IO.inspect(left, label: "CYCLING", charlists: :as_lists)
    # Cycle the left back to the right, but make sure we keep 7 available
    [seven, six, five, four, three, two, one | tail] = left
    new_left = [seven, six, five, four, three, two, one]
    new_right = Enum.reverse(tail)
    _high_score(players, max_num, next_num, new_left, new_right, scores)
  end
  defp _high_score(players, max_num, next_num, left, right, scores) when rem(next_num, 23) == 0 do
    #IO.inspect([Enum.reverse(left), right], charlists: :as_lists)
    current_player = rem(next_num, players)
    current_player_score = Map.get(scores, current_player, 0)

    # Pop seven off the left side and move six over to the right.
    [current, one, two, three, four, five, six, seven | left_tail] = left
    new_right = [five, four, three, two, one, current | right]

    new_scores = Map.put(scores, current_player, current_player_score + seven + next_num)
    _high_score(players, max_num, next_num + 1, [six | left_tail], new_right, new_scores)
  end
  defp _high_score(players, max_num, next_num, left, right, scores) do
    #IO.inspect([Enum.reverse(left), right], charlists: :as_lists)
    [right_head|right_tail] = right
    _high_score(players, max_num, next_num + 1, [next_num, right_head | left], right_tail, scores)
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
