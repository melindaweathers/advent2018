defmodule Day16 do
  use Bitwise

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

  def regget(register, x), do: Enum.at(register, x)
  def regset(register, x, val), do: List.update_at(register, x, fn(_) -> val end)

  # addr (add register) stores into register C the result of adding register A and register B.
  def addr([a, b, c], reg), do: regset(reg, c, regget(reg, a) + regget(reg, b))
  # addi (add immediate) stores into register C the result of adding register A and value B.
  def addi([a, b, c], reg), do: regset(reg, c, regget(reg, a) + b)

  #mulr (multiply register) stores into register C the result of multiplying register A and register B.
  def mulr([a, b, c], reg), do: regset(reg, c, regget(reg, a) * regget(reg, b))
  #muli (multiply immediate) stores into register C the result of multiplying register A and value B.
  def muli([a, b, c], reg), do: regset(reg, c, regget(reg, a) * b)

  #banr (bitwise AND register) stores into register C the result of the bitwise AND of register A and register B.
  def banr([a, b, c], reg), do: regset(reg, c, regget(reg, a) &&& regget(reg, b))
  #bani (bitwise AND immediate) stores into register C the result of the bitwise AND of register A and value B.
  def bani([a, b, c], reg), do: regset(reg, c, regget(reg, a) &&& b)

  #borr (bitwise OR register) stores into register C the result of the bitwise OR of register A and register B.
  def borr([a, b, c], reg), do: regset(reg, c, bor(regget(reg, a), regget(reg, b)))
  #bori (bitwise OR immediate) stores into register C the result of the bitwise OR of register A and value B.
  def bori([a, b, c], reg), do: regset(reg, c, bor(regget(reg, a), b))



  def run do
    IO.inspect(Day16.build_instructions("inputs/day16a-sample.txt"))
  end
end
