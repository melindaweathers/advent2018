defmodule Day19 do
  require ElfCode

  def execute_instructions(ip, instructions) do
    _execute_instructions(ip, instructions, {0, 0, 0, 0, 0, 0})
  end
  def execute_instructions(ip, instructions, reg) do
    _execute_instructions(ip, instructions, reg)
  end
  defp _execute_instructions(ip, instructions, reg) do
    instruction = Map.get(instructions, ElfCode.regget(reg, ip), :exit)
    if instruction == :exit do
      ElfCode.addi({ip, -1, ip}, reg)
    else
      {method,a,b,c} = instruction
      new_reg = apply(ElfCode, method, [{a,b,c},reg])
      #IO.inspect([reg, instruction, new_reg])
      _execute_instructions(ip, instructions, ElfCode.addi({ip, 1, ip}, new_reg))
    end
  end

  def run do
    {sample_ip, sample_instructions} = ElfCode.build_instructions("inputs/day19-sample.txt")
    IO.inspect(sample_instructions)

    {ip, instructions} = ElfCode.build_instructions("inputs/day19.txt")
    IO.inspect(execute_instructions(ip, instructions), label: "First Star")
    # Solved separately!
    # IO.inspect(execute_instructions(ip, instructions, {1, 0, 0, 0, 0, 0}), label: "Second Star")
  end
end
