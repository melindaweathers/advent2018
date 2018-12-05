# mix run -e 'Day3.run'
defmodule Day3 do
  def load_claims(filename) do
    strings = File.stream!(filename) |> Stream.map(&String.trim_trailing/1) |> Enum.to_list
    _load_claims(strings, [])
  end
  defp _load_claims([], claims), do: claims
  defp _load_claims([head|tail], claims) do
    [_, id, x, y, width, height] = String.split(head, ["#", " @ ", ",", ": ", "x"])
    claim = [id: String.to_integer(id), x: String.to_integer(x), y: String.to_integer(y), width: String.to_integer(width), height: String.to_integer(height)]
    _load_claims(tail, [claim|claims])
  end

  def canvas_size(claims), do: _canvas_size(claims, 0)
  defp _canvas_size([], max_dimension), do: max_dimension + 1
  defp _canvas_size([head|tail], max_dimension) do
    this_width = head[:width] + head[:x]
    this_height = head[:height] + head[:y]
    best = Enum.max([this_width, this_height, max_dimension])
    _canvas_size(tail, best)
  end

  def build_matrix(size, claim) do
    Matrex.new(size, size, fn row, col -> get_matrix_val(row, col, claim) end)
  end
  def get_matrix_val(row, col, claim) do
    if col > claim[:x] && col <= claim[:x] + claim[:width] && row > claim[:y] && row <= claim[:y] + claim[:height], do: 1, else: 0
  end
  def build_matrix_for_all_claims(claims) do
    size = canvas_size(claims)
    zeros = Matrex.zeros(size)
    _build_matrix_for_all_claims(claims, size, zeros)
  end
  def _build_matrix_for_all_claims([], _, matrix), do: matrix
  def _build_matrix_for_all_claims([head|tail], size, matrix) do
    _build_matrix_for_all_claims(tail, size, Matrex.add(matrix, build_matrix(size, head)))
  end

  def count_overlaps(matrix) do
    IO.puts("Counting overlaps")
    max = matrix[:max]
    normalized = Matrex.divide(Matrex.subtract(matrix, 1), max)
    ceil = Matrex.apply(normalized, :ceil)
    ceil[:sum]
  end

  def run do
    sample_claims = load_claims("inputs/day3-sample.txt")
    sample_matrix = build_matrix_for_all_claims(sample_claims)
    IO.inspect(count_overlaps(sample_matrix), label: "Sample overlaps (should be 4)")

    IO.puts("Full Size Claims")
    full_claims = load_claims("inputs/day3.txt")
    full_matrix = build_matrix_for_all_claims(full_claims)
    IO.inspect(count_overlaps(full_matrix), label: "First Star overlaps")
  end
end
