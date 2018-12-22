defmodule ElfCode do
  use Bitwise

  def build_instructions(filename) do
    [{:"#ip", ip}|instructions] = File.stream!(filename)
      |> Stream.map(&(build_instruction(&1)))
      |> Enum.to_list()
    instruction_map = instructions |> Enum.with_index(0) |> Enum.map(fn {k,v}->{v,k} end) |> Map.new
    {ip, instruction_map}
  end

  # #ip 1
  # seti 1 8 2
  def build_instruction(line) do
    tokens = String.trim(line) |> String.split()
    [instr | list] = tokens
    [String.to_atom(instr) | (list |> Enum.map(&(String.to_integer(&1))))] |> List.to_tuple
  end

  def regget(register, x), do: elem(register, x)
  def regset(register, x, val), do: put_elem(register, x, val)

  # addr (add register) stores into register C the result of adding register A and register B.
  def addr({a, b, c}, reg), do: regset(reg, c, regget(reg, a) + regget(reg, b))
  # addi (add immediate) stores into register C the result of adding register A and value B.
  def addi({a, b, c}, reg), do: regset(reg, c, regget(reg, a) + b)

  #mulr (multiply register) stores into register C the result of multiplying register A and register B.
  def mulr({a, b, c}, reg), do: regset(reg, c, regget(reg, a) * regget(reg, b))
  #muli (multiply immediate) stores into register C the result of multiplying register A and value B.
  def muli({a, b, c}, reg), do: regset(reg, c, regget(reg, a) * b)

  #banr (bitwise AND register) stores into register C the result of the bitwise AND of register A and register B.
  def banr({a, b, c}, reg), do: regset(reg, c, regget(reg, a) &&& regget(reg, b))
  #bani (bitwise AND immediate) stores into register C the result of the bitwise AND of register A and value B.
  def bani({a, b, c}, reg), do: regset(reg, c, regget(reg, a) &&& b)

  #borr (bitwise OR register) stores into register C the result of the bitwise OR of register A and register B.
  def borr({a, b, c}, reg), do: regset(reg, c, bor(regget(reg, a), regget(reg, b)))
  #bori (bitwise OR immediate) stores into register C the result of the bitwise OR of register A and value B.
  def bori({a, b, c}, reg), do: regset(reg, c, bor(regget(reg, a), b))

  #setr (set register) copies the contents of register A into register C. (Input B is ignored.)
  def setr({a, _, c}, reg), do: regset(reg, c, regget(reg, a))
  #seti (set immediate) stores value A into register C. (Input B is ignored.)
  def seti({a, _, c}, reg), do: regset(reg, c, a)

  #gtir (greater-than immediate/register) sets register C to 1 if value A is greater than register B. Otherwise, register C is set to 0.
  def gtir({a, b, c}, reg), do: regset(reg, c, (if a > regget(reg, b), do: 1, else: 0))
  #gtri (greater-than register/immediate) sets register C to 1 if register A is greater than value B. Otherwise, register C is set to 0.
  def gtri({a, b, c}, reg), do: regset(reg, c, (if regget(reg, a) > b, do: 1, else: 0))
  #gtrr (greater-than register/register) sets register C to 1 if register A is greater than register B. Otherwise, register C is set to 0.
  def gtrr({a, b, c}, reg), do: regset(reg, c, (if regget(reg, a) > regget(reg, b), do: 1, else: 0))

  #eqir (equal immediate/register) sets register C to 1 if value A is equal to register B. Otherwise, register C is set to 0.
  def eqir({a, b, c}, reg), do: regset(reg, c, (if a == regget(reg, b), do: 1, else: 0))
  #eqri (equal register/immediate) sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0.
  def eqri({a, b, c}, reg), do: regset(reg, c, (if regget(reg, a) == b, do: 1, else: 0))
  #eqrr (equal register/register) sets register C to 1 if register A is equal to register B. Otherwise, register C is set to 0.
  def eqrr({a, b, c}, reg), do: regset(reg, c, (if regget(reg, a) == regget(reg, b), do: 1, else: 0))
end
