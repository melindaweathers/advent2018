# mix run -e 'Day2.run'
defmodule Day2 do
  def words_from_file(filename) do
    File.stream!(filename) |> Stream.map(&String.trim_trailing/1) |> Enum.to_list
  end

  # Check the current count has update has_twos, has_threes accordingly
  def check_counts(count, _, has_threes) when count == 2, do: [1, has_threes]
  def check_counts(count, has_twos, _) when count == 3, do: [has_twos, 1]
  def check_counts(_, has_twos, has_threes), do: [has_twos, has_threes]

  def has_twos_threes(str) do
    [head|tail] = String.graphemes(str) |> Enum.sort()
    _has_twos_threes(tail, head, 1, 0, 0)
  end
  # Exit early if we've found both counts
  defp _has_twos_threes(_, _, _, 1, 1), do: [1, 1]
  # List is empty. Check final count and return result
  defp _has_twos_threes([], _, count, has_twos, has_threes), do: check_counts(count, has_twos, has_threes)
  # Continuing with previous char. Add to count.
  defp _has_twos_threes([head|tail], char, count, has_twos, has_threes) when head == char do
    _has_twos_threes(tail, char, count + 1, has_twos, has_threes)
  end
  # New char. Check previous counts and continue.
  defp _has_twos_threes([head|tail], _, count, has_twos, has_threes) do
    [has_twos, has_threes] = check_counts(count, has_twos, has_threes)
    _has_twos_threes(tail, head, 1, has_twos, has_threes)
  end

  def checksum(filename), do: _checksum(words_from_file(filename), 0, 0)
  defp _checksum([], twos, threes), do: twos * threes
  defp _checksum([head|tail], twos, threes) do
    [has_twos, has_threes] = has_twos_threes(head)
    _checksum(tail, twos + has_twos, threes + has_threes)
  end

  # Determine whether two words match each other with exactly one mistake
  def matches?(word1, word2), do: _matches?(String.graphemes(word1), String.graphemes(word2), 0)
  defp _matches?([], [], 1), do: true
  defp _matches?(_, _, mistakes) when mistakes > 1, do: false
  defp _matches?([head1|tail1], [head2|tail2], mistakes) when head1 == head2, do: _matches?(tail1, tail2, mistakes)
  defp _matches?([head1|tail1], [head2|tail2], mistakes), do: _matches?(tail1, tail2, mistakes + 1)

  # Find the matching labels from a file
  def find_matching(filename) do
    [first_word|other_words] = words_from_file(filename)
    _find_matching(first_word, other_words, other_words)
  end
  defp _find_matching(_, [], []), do: :no_matches_found
  defp _find_matching(_, [], [next_word|other_words]), do: _find_matching(next_word, other_words, other_words)
  defp _find_matching(word, [head|tail], other_words) do
    if matches?(word, head) do
      common_letters(word, head)
    else
      _find_matching(word, tail, other_words)
    end
  end

  # This is just formatting output really
  defp common_letters(word1, word2), do: _common_letters(String.graphemes(word1), String.graphemes(word2), [])
  defp _common_letters([], [], letters) , do: String.reverse(Enum.join(letters))
  defp _common_letters([head1|tail1], [head2|tail2], letters) when head1 == head2, do: _common_letters(tail1, tail2, [head1|letters])
  defp _common_letters([head1|tail1], [head2|tail2], letters), do: _common_letters(tail1, tail2, letters)

  def run do
    IO.inspect(has_twos_threes("abcdef"), label: "Should be 0, 0")
    IO.inspect(has_twos_threes("bababc"), label: "Should be 1, 1")
    IO.inspect(has_twos_threes("abbcde"), label: "Should be 1, 0")
    IO.inspect(has_twos_threes("abcccd"), label: "Should be 0, 1")
    IO.inspect(has_twos_threes("aabcdd"), label: "Should be 1, 0")
    IO.inspect(has_twos_threes("abcdee"), label: "Should be 1, 0")
    IO.inspect(has_twos_threes("ababab"), label: "Should be 0, 1")

    IO.puts "CHECKSUM"
    IO.inspect(checksum("inputs/day2-sample.txt"), label: "Should be 12")
    IO.inspect(checksum("inputs/day2.txt"), label: "FIRST STAR")

    IO.puts "MATCHING BOXES"
    IO.inspect(matches?("abcde", "axcye"), label: "Should be false")
    IO.inspect(matches?("fghij", "fguij"), label: "Should be true")
    IO.inspect(find_matching("inputs/day2-sample2.txt"), label: "Sample input")
    IO.inspect(find_matching("inputs/day2.txt"), label: "Second star input")
  end
end

