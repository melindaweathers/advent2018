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

  #setr (set register) copies the contents of register A into register C. (Input B is ignored.)
  def setr([a, _, c], reg), do: regset(reg, c, regget(reg, a))
  #seti (set immediate) stores value A into register C. (Input B is ignored.)
  def seti([a, _, c], reg), do: regset(reg, c, a)

  #gtir (greater-than immediate/register) sets register C to 1 if value A is greater than register B. Otherwise, register C is set to 0.
  def gtir([a, b, c], reg), do: regset(reg, c, (if a > regget(reg, b), do: 1, else: 0))
  #gtri (greater-than register/immediate) sets register C to 1 if register A is greater than value B. Otherwise, register C is set to 0.
  def gtri([a, b, c], reg), do: regset(reg, c, (if regget(reg, a) > b, do: 1, else: 0))
  #gtrr (greater-than register/register) sets register C to 1 if register A is greater than register B. Otherwise, register C is set to 0.
  def gtrr([a, b, c], reg), do: regset(reg, c, (if regget(reg, a) > regget(reg, b), do: 1, else: 0))

  #eqir (equal immediate/register) sets register C to 1 if value A is equal to register B. Otherwise, register C is set to 0.
  def eqir([a, b, c], reg), do: regset(reg, c, (if a == regget(reg, b), do: 1, else: 0))
  #eqri (equal register/immediate) sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0.
  def eqri([a, b, c], reg), do: regset(reg, c, (if regget(reg, a) == b, do: 1, else: 0))
  #eqrr (equal register/register) sets register C to 1 if register A is equal to register B. Otherwise, register C is set to 0.
  def eqrr([a, b, c], reg), do: regset(reg, c, (if regget(reg, a) == regget(reg, b), do: 1, else: 0))

  def all_fns do
    [:addr, :addi, :mulr, :muli, :banr, :bani, :borr, :bori, :setr, :seti, :gtir, :gtri, :gtrr, :eqir, :eqri, :eqrr]
  end

  def matching_fns(sample), do: _matching_fns(sample, all_fns(), [])
  defp _matching_fns(_, [], fns), do: fns
  defp _matching_fns(sample, [head|tail], fns) do
    {before, [_,a,b,c], aft} = sample
    if apply(Day16, head, [[a,b,c], before]) == aft do
      _matching_fns(sample, tail, [head|fns])
    else
      _matching_fns(sample, tail, fns)
    end
  end

  def find_over_three_matches(samples), do: _find_over_three_matches(samples, 0)
  defp _find_over_three_matches([], count), do: count
  defp _find_over_three_matches([head|tail], count) do
    if Enum.count(matching_fns(head)) >= 3 do
      _find_over_three_matches(tail, count + 1)
    else
      _find_over_three_matches(tail, count)
    end
  end

  def run do
    sample_samples = Day16.build_instructions("inputs/day16a-sample.txt")
    IO.inspect(find_over_three_matches(sample_samples), label: "First Sample")

    samples = Day16.build_instructions("inputs/day16a.txt")
    IO.inspect(find_over_three_matches(samples), label: "First Star")
  end
end
