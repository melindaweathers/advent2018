defmodule Day7 do
  def read_lines(filename) do
    File.stream!(filename) |> Stream.map(&String.trim_trailing/1) |> Enum.to_list
  end

  def build_rules(filename) do
    _build_rules(read_lines(filename), %{})
  end
  defp _build_rules([], rules), do: rules
  defp _build_rules([head|tail], rules) do
    ["Step", prereq, "must", "be", "finished", "before", "step", step, "can", "begin."] = String.split(head)
    existing_step = Map.get(rules, step, [])
    map_with_step = Map.put(rules, step, [prereq|existing_step])
    if rules[prereq] do
      _build_rules(tail,map_with_step)
    else
      _build_rules(tail,Map.put(map_with_step, prereq, []))
    end
  end

  def find_next_step(rules, completed, in_flight) do
    possible_steps = Map.keys(rules) |> Enum.sort
    _find_next_step(possible_steps, rules, completed, in_flight)
  end
  defp _find_next_step([], _, _, _), do: nil
  defp _find_next_step([head|tail], rules, completed, in_flight) do
    if !(head in in_flight) && !(head in completed) && Enum.all?(Map.get(rules, head, []), fn prereq -> prereq in completed end) do
      head
    else
      _find_next_step(tail, rules, completed, in_flight)
    end
  end

  def find_step_order(rules), do: _find_step_order(rules, []) |> Enum.reverse() |> Enum.join()
  defp _find_step_order(rules, completed) do
    next_step = find_next_step(rules, completed, [])
    if next_step do
      _find_step_order(rules, [next_step|completed])
    else
      completed
    end
  end

  def progress_tasks(in_flight, completed), do: _progress_tasks(in_flight, [], completed)
  defp _progress_tasks([], result, completed), do: [result, completed]
  defp _progress_tasks([head|tail], result, completed) do
    if head[:time] == 1 do
      _progress_tasks(tail, result, [head[:task]|completed])
    else
      updated_task = [task: head[:task], time: head[:time] - 1]
      _progress_tasks(tail, [updated_task|result], completed)
    end
  end

  def add_new_tasks(num_workers, extra_time, rules, in_flight, completed) do
    in_flight_steps = Enum.map(in_flight, fn step -> step[:task] end)
    next_step = find_next_step(rules, completed, in_flight_steps)
    if next_step && Enum.count(in_flight) < num_workers do
      new_task = [task: next_step, time: List.first(String.to_charlist(next_step)) - 64 + extra_time]
      add_new_tasks(num_workers, extra_time, rules, [new_task|in_flight], completed)
    else
      in_flight
    end
  end

  def tick(num_workers, extra_time, rules, in_flight, completed) do
    # progress in_flight queues by 1
    [new_in_flight, new_completed] = progress_tasks(in_flight, completed)

    # add workers if possible
    added_in_flight = add_new_tasks(num_workers, extra_time, rules, new_in_flight, new_completed)

    # return results
    [added_in_flight, new_completed]
  end

  def find_times(num_workers, extra_time, rules) do
    [in_flight, completed] = tick(num_workers, extra_time, rules, [], [])
    _find_times(num_workers, extra_time, rules, in_flight, completed, 0)
  end
  defp _find_times(_, _, _, [], _, time), do: time
  defp _find_times(num_workers, extra_time, rules, in_flight, completed, time) do
    [new_in_flight, new_completed] = tick(num_workers, extra_time, rules, in_flight, completed)
    _find_times(num_workers, extra_time, rules, new_in_flight, new_completed, time + 1)
  end

  def run do
    sample_rules = build_rules("inputs/day7-sample.txt")
    IO.inspect(find_step_order(sample_rules), label: "Sample Step Order")

    rules = build_rules("inputs/day7.txt")
    IO.inspect(find_step_order(rules), label: "First Star Step Order")

    IO.inspect(find_times(2, 0, sample_rules), label: "Sample Total Time")

    IO.inspect(find_times(5, 60, rules), label: "Second Star Total Time")
  end
end
