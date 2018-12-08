defmodule Day6 do
  def read_lines(filename) do
    File.stream!(filename)
      |> Stream.map(&String.trim_trailing/1)
      |> Stream.map(&(String.split(&1, ", ")))
      |> Stream.with_index()
      |> Enum.map(fn {[x,y], line} -> [ index: line, x: String.to_integer(x), y: String.to_integer(y) ] end)
      |> Enum.to_list
  end

  def max_row_col (coords) do
    x = coords |> Enum.map(&(&1[:x])) |> Enum.max
    y = coords |> Enum.map(&(&1[:y])) |> Enum.max
    [x + 1, y + 1]
  end

  def closest_point(coords, x, y), do: _closest_point(coords, x, y, 1000000, "")
  defp _closest_point([], _, _, closest_dist, closest_coord), do: [dist: closest_dist, index: closest_coord]
  defp _closest_point([head|tail], x, y, closest_dist, closest_coord) do
    dist = abs(x - head[:x]) + abs(y - head[:y])
    cond do
      dist == closest_dist ->
        _closest_point(tail, x, y, closest_dist, nil)
      dist < closest_dist ->
        _closest_point(tail, x, y, dist, head[:index])
      true ->
        _closest_point(tail, x, y, closest_dist, closest_coord)
    end
  end

  def map_value(coords, x, y, max_x, max_y) do
    point = closest_point(coords, x, y)
    if x == 0 || x == max_x || y == 0 || y == max_y do
      {:edge, point}
    else
      {:center, point}
    end
  end

  def build_map(coords) do
    [max_x, max_y] = max_row_col(coords)
    Enum.map(0..max_x, fn(x) ->
      Enum.map(0..max_y, fn(y) ->
        map_value(coords, x, y, max_x, max_y)
      end)
    end)
  end

  def edge_indices(map), do: _edge_indices(map, MapSet.new())
  defp _edge_indices([], indices), do: indices
  defp _edge_indices([[]|other_cols], indices), do: _edge_indices(other_cols, indices)
  defp _edge_indices([[{:center, _}|other_rows]|other_cols], indices), do: _edge_indices([other_rows|other_cols], indices)
  defp _edge_indices([[{:edge, point}|other_rows]|other_cols], indices) do
    _edge_indices([other_rows|other_cols], MapSet.put(indices, point[:index]))
  end

  def area_counts(map, infinites), do: _area_counts(map, infinites, %{})
  def _area_counts([], _, counts), do: counts
  def _area_counts([[]|other_cols], infinites, counts), do: _area_counts(other_cols, infinites, counts)
  def _area_counts([[{:edge, _}|other_rows]|other_cols], infinites, counts), do: _area_counts([other_rows|other_cols], infinites, counts)
  def _area_counts([[{:center, point}|other_rows]|other_cols], infinites, counts) do
    if MapSet.member?(infinites, point[:index]) do
      _area_counts([other_rows|other_cols], infinites, counts)
    else
      existing_count = Map.get(counts, point[:index], 0)
      _area_counts([other_rows|other_cols], infinites, Map.put(counts, point[:index], existing_count + 1))
    end
  end

  def find_largest_area(coords) do
    map = build_map(coords)
    infinites = edge_indices(map)
    counts = area_counts(map, infinites)
    counts |> Enum.map(fn {_index, value} -> value end) |> Enum.max
  end

  def run do
    sample_coords = read_lines("inputs/day6-sample.txt")
    IO.inspect(find_largest_area(sample_coords), label: "Sample max area")

    coords = read_lines("inputs/day6.txt")
    IO.inspect(find_largest_area(coords), label: "First Star max area")
  end
end
