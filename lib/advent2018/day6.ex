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
  defp _closest_point(_, _, _, 0, _), do: [dist: 0, index: nil]
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

  #def build_map(coords) do
    #[max_x, max_y] = max_row_col(coords)
    #Enum.map(0..max_x, fn(x) ->
      #ys = Enum.map(0..max_y, fn(y) ->
        #point = closest_point(coords, x, y)
        #if x == 0 || x == max_x || y == 0 || y == max_y do
          ## TODO: This is wrong
          #area_counts[point[:index]] = [:infinite, 0, nil]
        #else
          #existing_counts = area_counts[points[:index]]
          ## TODO: Update the counts unless it's already infinite.


        #end
      #end)
    #end)
  #end

  #def find_largest_area(coords) do
    #map = build_map(coords)
    #area_counts = _find_largest_area(map, %{})
    #area_counts # TODO: find the largest
  #end
  #defp _find_largest_area([[[head|remaining_rows]|remaining_cols], counts) do
    #if 

  #end


  def run do
    sample_coords = read_lines("inputs/day6-sample.txt")
    #IO.inspect(build_map(sample_coords))

  end
end
