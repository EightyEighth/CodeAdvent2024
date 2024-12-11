defmodule Advent.Day1 do


  def parse({:ok, data} = _) do
    stream_list = data
      |> String.split("\n")
      |> Enum.join(" ")
      |> String.split
      |> Enum.map(&String.to_integer/1)

    first_list =
      stream_list
      |> Enum.with_index
      |> Enum.filter(fn {_elem, index} -> rem(index, 2) == 0 end)
      |> Enum.map(fn {elem, _index} -> elem end)
      |> Enum.sort

    second_list =
      stream_list
      |> Enum.with_index
      |> Enum.filter(fn {_elem, index} -> rem(index, 2) != 0 end)
      |> Enum.map(fn {elem, _index} -> elem end)
      |> Enum.sort

      [first_list, second_list]

  end

  def shearch_distace([list1 | tail]) do
    [list2 | _] = tail
    Enum.zip(list1, list2)
      |> Enum.map(fn {elem1, elem2} -> abs(elem1 - elem2) end)
      |> Enum.sum
  end

  def total_simmilarity_score([list1 | tail]) do
    [list2 | _] = tail
    Enum.map(list1, fn elem1 -> Enum.count(list2, fn x -> x == elem1 end) * elem1 end)
    |> Enum.sum
  end
end
