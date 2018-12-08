defmodule Day8 do
  defmodule Node do
    defstruct num_children: 0, num_metadata: 0, children: [], metadata: []
  end

  def read_data(filename) do
    File.read!(filename) |> String.trim_trailing |> String.split |> Enum.map(&String.to_integer/1)
  end

  def split_metadata(data, num_metadata), do: _split_metadata(data, num_metadata, [])
  defp _split_metadata(data, 0, metadata), do: [Enum.reverse(metadata), data]
  defp _split_metadata([head|tail], num_metadata, metadata) do
    _split_metadata(tail, num_metadata - 1, [head|metadata])
  end

  def build_children(num_children, data), do: _build_children(num_children, data, [])
  defp _build_children(0, data, children), do: [children |> Enum.reverse(), data]
  defp _build_children(num_children, data, children) do
    [child_num_children|[child_num_metadata|tail]] = data
    [child_children, remaining] = build_children(child_num_children, tail)
    [metadata, rest] = split_metadata(remaining, child_num_metadata)
    child = %Node{num_children: child_num_children, num_metadata: child_num_metadata, children: child_children, metadata: metadata}
    _build_children(num_children - 1, rest, [child|children])
  end

  def build_tree(filename) do
    data = read_data(filename)
    [[root|_], []] = build_children(1, data)
    root
  end

  defp sum_metadata(node) do
    Enum.sum(node.metadata) + (node.children |> Enum.map(&(sum_metadata(&1))) |> Enum.sum)
  end

  def node_value(nil), do: 0
  def node_value(node) do
    if node.num_children == 0 do
      Enum.sum(node.metadata)
    else
      sum_children(node.children, node.metadata)
    end
  end

  def sum_children(children, metadata), do: _sum_children(children, metadata, 0)
  defp _sum_children(_, [], sum), do: sum
  defp _sum_children(children, [head|tail], sum) do
    child = Enum.at(children, head - 1)
    _sum_children(children, tail, sum + node_value(child))
  end

  def run do
    sample_tree = build_tree("inputs/day8-sample.txt")
    IO.inspect(sum_metadata(sample_tree), label: "Sample Tree Metadata Count")

    tree = build_tree("inputs/day8.txt")
    IO.inspect(sum_metadata(tree), label: "First Star Metadata Count")

    IO.inspect(node_value(sample_tree), label: "Sample Tree Value")
    IO.inspect(node_value(tree), label: "Second Star Tree Value")
  end
end
