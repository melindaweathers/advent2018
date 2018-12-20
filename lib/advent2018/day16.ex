defmodule Day16 do

  def build_instructions(filename) do
    File.stream!(filename)
      |> Stream.chunk_every(4)
      |> Stream.map(&(build_instruction(&1)))
      |> Enum.to_list()
  end

  #Before: [1, 1, 2, 0]
  #8 1 0 3
  #After:  [1, 1, 2, 1]
  def build_instruction(chunk) do
    [before, instruction, aft, _] = Enum.to_list(chunk)
    {build_instruction_part(before), build_instruction_part(instruction), build_instruction_part(aft)}
  end
  def build_instruction_part(line) do
    words = String.trim(line) |> String.split([", ", " ", "[", "]"])
    _build_instruction_part(words) |> Enum.map(&(String.to_integer(&1)))
  end
  defp _build_instruction_part(["Before:", "", a, b, c, d, ""]), do: [a,b,c,d]
  defp _build_instruction_part(["After:", "", "", a, b, c, d, ""]), do: [a,b,c,d]
  defp _build_instruction_part([a, b, c, d]), do: [a,b,c,d]


  def run do
    IO.inspect(Day16.build_instructions("inputs/day16a-sample.txt"))
  end
end
