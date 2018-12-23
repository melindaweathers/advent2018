defmodule Day13 do
  defmodule Cart do
    defstruct direction: ">", x: 0, y: 0, turns: [:left, :straight, :right]
  end

  def load_track(filename) do
    File.stream!(filename)
      |> Stream.map(&(String.trim_trailing(&1,"\n")))
      |> Stream.map(&(String.graphemes/1))
      |> Stream.with_index
      |> Enum.to_list
      |> load_track_rows
  end

  def load_track_rows(rows_with_index) do
    Enum.reduce(rows_with_index, {%{},[]}, fn({row,y}, {rows, carts}) ->
      {row_chars, row_carts} = Enum.reduce(Enum.with_index(row), {%{},[]}, fn({char,x}, acc) ->
        load_track_char(char, x, y, acc)
      end)
      {Map.put(rows, y, row_chars), carts ++ row_carts}
    end)
  end

  def load_track_char(char, x, y, {chars, carts}) when char in [">","<"] do
    { Map.put(chars, x, "-"), [%Cart{direction: char, x: x, y: y}|carts] }
  end
  def load_track_char(char, x, y, {chars, carts}) when char in ["v","^"] do
    { Map.put(chars, x, "|"), [%Cart{direction: char, x: x, y: y}|carts] }
  end
  def load_track_char(char, x, _, {chars, carts}), do: { Map.put(chars, x, char), carts }

  def sort_carts(carts) do
    Enum.sort(carts, fn(cart1,cart2) -> (cart1.y < cart2.y) || (cart1.y == cart2.y && cart1.x <= cart2.x) end)
  end

  def collision?(moving_cart, other_carts) do
    Enum.any?(other_carts, fn cart -> cart.x == moving_cart.x && cart.y == moving_cart.y end)
  end

  def next_cart_pos(%Cart{direction: ">"} = cart), do: {cart.x + 1, cart.y}
  def next_cart_pos(%Cart{direction: "<"} = cart), do: {cart.x - 1, cart.y}
  def next_cart_pos(%Cart{direction: "v"} = cart), do: {cart.x, cart.y + 1}
  def next_cart_pos(%Cart{direction: "^"} = cart), do: {cart.x, cart.y - 1}

  def turn(:right, ">"), do: "v"
  def turn(:right, "v"), do: "<"
  def turn(:right, "<"), do: "^"
  def turn(:right, "^"), do: ">"
  def turn(:left, ">"), do: "^"
  def turn(:left, "v"), do: ">"
  def turn(:left, "<"), do: "v"
  def turn(:left, "^"), do: "<"
  def turn(:straight, dir), do: dir

  def next_cart_orientation(cart, "+") do
    [a, b, c] = cart.turns
    {turn(a, cart.direction), [b, c, a]}
  end
  def next_cart_orientation(cart, char), do: {next_direction(cart.direction, char), cart.turns}

  def next_direction(">", "-"), do: ">"
  def next_direction("<", "-"), do: "<"
  def next_direction("^", "|"), do: "^"
  def next_direction("v", "|"), do: "v"
  def next_direction("^", "/"), do: ">"
  def next_direction("v", "/"), do: "<"
  def next_direction("<", "/"), do: "v"
  def next_direction(">", "/"), do: "^"
  def next_direction("^", "\\"), do: "<"
  def next_direction("v", "\\"), do: ">"
  def next_direction("<", "\\"), do: "^"
  def next_direction(">", "\\"), do: "v"

  def move_cart(track, cart) do
    {x, y} = next_cart_pos(cart)
    {dir, turns} = next_cart_orientation(cart, track[y][x])
    %Cart{direction: dir, x: x, y: y, turns: turns}
  end

  def move_carts(track, carts), do: _move_carts(track, sort_carts(carts), [])
  defp _move_carts(track, [], moved_carts), do: _move_carts(track, sort_carts(moved_carts), [])
  defp _move_carts(track, [cart|tail], moved_carts) do
    new_cart = move_cart(track, cart)
    #IO.inspect(new_cart)
    if collision?(new_cart, tail ++ moved_carts) do
      {new_cart.x, new_cart.y}
    else
      _move_carts(track, tail, [new_cart|moved_carts])
    end
  end

  def find_last_cart(track, carts), do: _find_last_cart(track, sort_carts(carts), [])
  defp _find_last_cart(_, [], [cart]), do: {cart.x, cart.y}
  defp _find_last_cart(track, [], moved_carts), do: _find_last_cart(track, sort_carts(moved_carts), [])
  defp _find_last_cart(track, [cart|tail], moved_carts) do
    new_cart = move_cart(track, cart)
    #IO.inspect(new_cart)
    cond do
      collision?(new_cart, tail) ->
        IO.inspect("Collision at #{new_cart.x},#{new_cart.y}")
        new_tail = Enum.reject(tail, fn cart -> cart.x == new_cart.x && cart.y == new_cart.y end)
        _find_last_cart(track, new_tail, moved_carts)
      collision?(new_cart, moved_carts) ->
        IO.inspect("Collision at #{new_cart.x},#{new_cart.y}")
        new_moved_carts = Enum.reject(moved_carts, fn cart -> cart.x == new_cart.x && cart.y == new_cart.y end)
        _find_last_cart(track, tail, new_moved_carts)
      true ->
        _find_last_cart(track, tail, [new_cart|moved_carts])
    end
  end

  def run do
    {sample_track, sample_carts} = (load_track("inputs/day13-sample.txt"))
    IO.inspect(move_carts(sample_track, sample_carts), label: "Should be 7,3")

    {sample_trackb, sample_cartsb} = (load_track("inputs/day13b-sample.txt"))
    IO.inspect(find_last_cart(sample_trackb, sample_cartsb), label: "Should be 6,4")

    {track, carts} = (load_track("inputs/day13.txt"))
    IO.inspect(move_carts(track, carts), label: "First Star")

    IO.inspect(find_last_cart(track, carts), label: "Second star")
  end
end
