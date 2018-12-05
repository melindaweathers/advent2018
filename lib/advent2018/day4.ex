defmodule Day4 do
  def load_times(filename) do
    strings = File.stream!(filename) |> Stream.map(&String.trim_trailing/1) |> Enum.to_list
    times = _load_times(strings, [])
    add_guard_ids(Enum.sort_by(times, fn(t) -> t[:time] end))
  end
  defp _load_times([], times), do: times
  defp _load_times([head|tail], times) do
    [_, time, desc] = String.split(head, ["[", "]"])
    row = [time: time, desc: desc]
    _load_times(tail, [row|times])
  end

  def parse_desc(["Guard", id, "begins", "shift"], _), do: [id, "begins"]
  def parse_desc([action, _], id), do: [id, action]

  def add_guard_ids(times), do: Enum.reverse(_add_guard_ids(times, "", []))
  defp _add_guard_ids([], _, recs), do: recs
  defp _add_guard_ids([head|tail], last_id, recs) do
    [id, action] = parse_desc(String.split(head[:desc]), last_id)
    this_rec = [time: head[:time], id: id, action: action]
    _add_guard_ids(tail, id, [this_rec|recs])
  end

  def empty_hours do
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
  end

  def update_hours(hours, start_time, end_time) do
    [_, start_minute_str] = String.split(start_time, [":"])
    [_, end_minute_str] = String.split(end_time, [":"])
    start_minute = String.to_integer(start_minute_str)
    end_minute = String.to_integer(end_minute_str)
    hours |> Enum.with_index |> Enum.map(fn({x, i}) -> if i >= start_minute && i < end_minute, do: 1, else: x end)
  end

  def build_night_rows(times) do
    [head|tail] = times
    _build_night_rows(tail, head[:id], empty_hours, head[:time], "", [])
  end
  defp _build_night_rows([], id, hours, time_started, _, rows_so_far) do
    previous_row = [id: id, hours: hours, time: time_started]
    [previous_row|rows_so_far]
  end
  defp _build_night_rows([head|tail], id, hours, time_started, time_slept, rows_so_far) do
    cond do
      head[:action] == "begins" ->
        previous_row = [id: id, hours: hours, time: time_started]
        _build_night_rows(tail, head[:id], empty_hours, head[:time], "", [previous_row|rows_so_far])
      head[:action] == "falls" ->
        _build_night_rows(tail, id, hours, time_started, head[:time], rows_so_far)
      true ->
        updated_hours = update_hours(hours, time_slept, head[:time])
        _build_night_rows(tail, id, updated_hours, time_started, "", rows_so_far)
    end
  end

  def combine_night_rows(night_rows), do: _combine_night_rows(night_rows, %{}, 0, "")
  defp _combine_night_rows([], guard_map, max_sleep, max_guard), do: [guard_map, max_sleep, max_guard]
  defp _combine_night_rows([head|tail], guard_map, max_sleep, max_guard) do
    id = head[:id]
    old_hours = Map.get(guard_map, head[:id], empty_hours)
    hours = Enum.zip(head[:hours], old_hours) |> Enum.map(fn({x,y}) -> x + y end)
    sleep = Enum.sum(hours)
    if sleep > max_sleep do
      _combine_night_rows(tail, Map.put(guard_map, head[:id], hours), sleep, head[:id])
    else
      _combine_night_rows(tail, Map.put(guard_map, head[:id], hours), max_sleep, max_guard)
    end
  end

  # For the first star
  def guard_and_minute(guard_info) do
    [guard_map, _, max_guard] = guard_info
    guard_num = String.to_integer(String.slice(max_guard, 1..-1))
    guard_rec = Map.get(guard_map, max_guard)
    max_minute_amount = Enum.max(guard_rec)
    max_minute = Enum.find_index(guard_rec, fn x -> x == max_minute_amount end)
    guard_num * max_minute
  end

  # For the second star
  def max_guard_minute([guard_info, _, _]) do
    guard_list = for {k,v} <- guard_info, do: [id: k, hours: v]
    _max_guard_minute(guard_list, 0, 0, "")
  end
  defp _max_guard_minute([], max_minute, _, guard) do
    guard_num = String.to_integer(String.slice(guard, 1..-1))
    max_minute * guard_num
  end
  defp _max_guard_minute([head|tail], max_minute, max_times_asleep, guard) do
    this_max_times_asleep = Enum.max(head[:hours])
    if this_max_times_asleep > max_times_asleep do
      index = Enum.find_index(head[:hours], fn x -> x == this_max_times_asleep end)
      _max_guard_minute(tail, index, this_max_times_asleep, head[:id])
    else
      _max_guard_minute(tail, max_minute, max_times_asleep, guard)
    end
  end

  def run do
    times = Day4.load_times("inputs/day4-sample.txt")
    night_rows = build_night_rows(times)
    guard_info = combine_night_rows(night_rows)
    IO.inspect(guard_and_minute(guard_info), label: "Sample (should be 240)")

    star_times = Day4.load_times("inputs/day4.txt")
    star_night_rows = build_night_rows(star_times)
    star_guard_info = combine_night_rows(star_night_rows)
    IO.inspect(guard_and_minute(star_guard_info), label: "First Star")

    # Second Star
    IO.inspect(max_guard_minute(guard_info), label: "Second Star Sample, should be 4450")
    IO.inspect(max_guard_minute(star_guard_info), label: "Second Star")
  end
end
