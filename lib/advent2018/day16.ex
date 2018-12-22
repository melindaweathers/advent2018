defmodule Day16 do
  require ElfCode

  def build_instructions(filename) do
    File.stream!(filename)
      |> Stream.chunk_every(4)
      |> Stream.map(&(build_instruction(&1)))
      |> Enum.to_list()
  end

  def read_raw_instructions(filename) do
    File.stream!(filename)
      |> Stream.map(&(build_instruction_part(&1)))
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
    _build_instruction_part(words) |> Enum.map(&(String.to_integer(&1))) |> List.to_tuple
  end
  defp _build_instruction_part(["Before:", "", a, b, c, d, ""]), do: [a,b,c,d]
  defp _build_instruction_part(["After:", "", "", a, b, c, d, ""]), do: [a,b,c,d]
  defp _build_instruction_part([a, b, c, d]), do: [a,b,c,d]

  def all_fns do
    [:addr, :addi, :mulr, :muli, :banr, :bani, :borr, :bori, :setr, :seti, :gtir, :gtri, :gtrr, :eqir, :eqri, :eqrr]
  end

  def matching_fns(sample), do: _matching_fns(sample, all_fns(), [])
  def matching_fns(sample, fns), do: _matching_fns(sample, fns, [])
  defp _matching_fns(_, [], fns), do: fns
  defp _matching_fns(sample, [head|tail], fns) do
    {before, {_,a,b,c}, aft} = sample
    if apply(ElfCode, head, [{a,b,c}, before]) == aft do
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

  def execute_instructions(instructions, mappings) do
    _execute_instructions(instructions, mappings, {0, 0, 0, 0})
  end
  defp _execute_instructions([], _, reg), do: reg
  defp _execute_instructions([{i, a, b, c}|tail], mappings, reg) do
    new_reg = apply(ElfCode, mappings[i], [{a,b,c},reg])
    _execute_instructions(tail, mappings, new_reg)
  end

  def instruction_mappings(samples), do: _instruction_mappings(samples, %{})
  defp _instruction_mappings([], mappings), do: mappings
  defp _instruction_mappings([sample|tail], mappings) do
    {before, {i,a,b,c}, aft} = sample
    possible_fns = Map.get(mappings, i, all_fns)
    still_possible_fns = matching_fns(sample, possible_fns)
    _instruction_mappings(tail, Map.put(mappings, i, still_possible_fns))
  end

  def run do
    sample_samples = Day16.build_instructions("inputs/day16a-sample.txt")
    IO.inspect(find_over_three_matches(sample_samples), label: "First Sample")

    samples = Day16.build_instructions("inputs/day16a.txt")
    IO.inspect(find_over_three_matches(samples), label: "First Star")

    IO.inspect(instruction_mappings(samples))
    # Reduced by hand :O
    mappings = %{0 => :eqir, 1 => :borr, 2 => :addr, 3 => :gtri, 4 => :muli, 5 => :gtir, 6 => :mulr, 7 => :banr, 8 => :bori, 9 => :eqri, 10 => :eqrr, 11 => :bani, 12 => :setr, 13 => :gtrr, 14 => :addi, 15 => :seti}
    instructions = Day16.read_raw_instructions("inputs/day16b.txt")
    IO.inspect(execute_instructions(instructions, mappings))
  end
end
