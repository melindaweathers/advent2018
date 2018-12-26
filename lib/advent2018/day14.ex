defmodule Day14 do
  def next_ten_recipes(count) do
    _next_ten_recipes(count + 7, %{0 => 3, 1=> 7, 2 => 1, 3 => 0}, {0, 1, 3})
      |> Enum.reverse
      |> Enum.join("")
  end
  def _next_ten_recipes(-1, recipes, {_, _, last_index}) do
    Enum.map(1..10, fn(i) -> recipes[last_index - i - 1] end)
  end
  def _next_ten_recipes(0, recipes, {_, _, last_index}) do
    Enum.map(0..9, fn(i) -> recipes[last_index - i - 1] end)
  end
  def _next_ten_recipes(count, recipes, {first_elf, second_elf, last_index}) do
    {new_recipes, new_first_elf, new_second_elf, new_last_index} = next_recipes(recipes, {first_elf, second_elf, last_index})
    _next_ten_recipes(count - Enum.count(new_recipes), Map.merge(recipes, new_recipes), {new_first_elf, new_second_elf, new_last_index})
  end

  def next_recipes(recipes, {first_elf, second_elf, last_index}) do
    #print_recipes(recipes, first_elf, second_elf, last_index)
    first_elf_recipe = recipes[first_elf]
    second_elf_recipe = recipes[second_elf]
    {new_recipes, new_last_index} = get_new_recipes(first_elf_recipe + second_elf_recipe, last_index)
    new_first_elf = rem(first_elf + first_elf_recipe + 1, new_last_index + 1)
    new_second_elf = rem(second_elf + second_elf_recipe + 1, new_last_index + 1)
    {new_recipes, new_first_elf, new_second_elf, new_last_index}
  end

  def get_new_recipes(num, last_index) when num < 10, do: {%{last_index + 1 => num}, last_index + 1}
  def get_new_recipes(num, last_index) do
    [num1, num2] = num |> Integer.to_string(10) |> String.graphemes |> Enum.map(&String.to_integer/1)
    {%{last_index + 1 => num1, last_index + 2 => num2}, last_index + 2}
  end

  def print_recipes(recipes, first_elf, second_elf, last_index) do
    #IO.inspect({recipes, first_elf, second_elf, last_index})
    Enum.map(0..last_index, fn (index) ->
      cond do
        index == first_elf -> IO.write("(#{recipes[index]})")
        index == second_elf -> IO.write("[#{recipes[index]}]")
        true -> IO.write(" #{recipes[index]} ")
      end
    end)
    IO.puts("")
  end

  def count_recipes_until(until) do
    _count_recipes_until(until, %{0 => 3, 1=> 7, 2 => 1, 3 => 0}, {0, 1, 3})
  end
  def _count_recipes_until(until, recipes, {first_elf, second_elf, last_index}) do
    {new_recipes, new_first_elf, new_second_elf, new_last_index} = next_recipes(recipes, {first_elf, second_elf, last_index})
  end



  def run do
    IO.inspect(next_ten_recipes(9), label: "Should be 5158916779")
    IO.inspect(next_ten_recipes(5), label: "Should be 0124515891")
    IO.inspect(next_ten_recipes(18), label: "Should be 9251071085")
    IO.inspect(next_ten_recipes(2018), label: "Should be 5941429882")
    IO.inspect(next_ten_recipes(540391), label: "First Star")
  end
end
