defmodule Day13 do
  def load_track(filename) do
    chars = File.stream!(filename) |> Stream.map(&(String.trim_trailing(&1,"\n")))|> Stream.map(&(String.graphemes/1)) |> Enum.to_list
    Enum.reduce(Enum.with_index(chars), {Map.new(),[]}, fn({row,y}, acc) ->
      {rows, carts} = acc
      {row_chars, row_carts} = Enum.reduce(Enum.with_index(row), {Map.new(),[]}, fn({char,x}, acc) ->
        {chars, carts} = acc
        cond do
          char in ["<",">"] ->
            {Map.put(chars, x, "-"), [{char,x,y}|carts]}
          char in ["v","^"] ->
            {Map.put(chars, x, "|"), [{char,x,y}|carts]}
          true ->
            {Map.put(chars, x, char), carts}
        end
      end)
      {Map.put(rows, y, row_chars), carts ++ row_carts}
    end)
  end

  def run do
    IO.inspect(load_track("inputs/day13-sample.txt"))
  end
end
