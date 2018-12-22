defmodule Day21 do
  require ElfCode

  def execute_instructions(ip, instructions) do
    execute_instructions(ip, instructions, {0, 0, 0, 0, 0, 0})
  end
  def execute_instructions(ip, instructions, reg) do
    _execute_instructions(ip, instructions, reg, [])
  end
  defp _execute_instructions(ip, instructions, reg, haltvals) do
    instruction = Map.get(instructions, ElfCode.regget(reg, ip), :exit)
    if instruction == :exit do
      reg
    else
      #logreg(reg)
      {r1, r2, r3, r4, r5, r6} = reg
      {method,a,b,c} = instruction
      new_reg = apply(ElfCode, method, [{a,b,c},reg])
      if r2 == 29 do
        if r5 in haltvals do
          IO.inspect("First repeated val was #{r5}")
          [last_val|tail] = haltvals
          IO.inspect("Val before that was #{last_val}")
        else
          _execute_instructions(ip, instructions, ElfCode.addi({ip, 1, ip}, new_reg), [r5|haltvals])
        end
      else
        _execute_instructions(ip, instructions, ElfCode.addi({ip, 1, ip}, new_reg), haltvals)
      end
    end
  end

  def logreg({_,29,_,_,targ,_}), do: IO.inspect(targ)
  def logreg(reg) do
    #IO.inspect([reg, instruction, new_reg])
    #IO.gets "<Enter>"
  end

  def run do
    {ip, instructions} = ElfCode.build_instructions("inputs/day21.txt")
    # First star
    IO.inspect(execute_instructions(ip, instructions, {12420065, 0, 0, 0, 0, 0}))

    IO.inspect(execute_instructions(ip, instructions, {5, 0, 0, 0, 0, 0}))
  end
end
