defmodule Advent.Day4 do
  alias Hex.API.Key
  @word ["M", "A", "S"]
  @short_word ["A", "S"]

  @relative_vectors [
    [{1, 0}, {2, 0}, {3, 0}], # horizontal right
    [{-1, 0}, {-2, 0}, {-3, 0} ], # horizontal left
    [{0, 1}, {0, 2}, {0, 3}], # vertical up
    [{0, -1}, {0, -2}, {0, -3}], # vertical up
    [{1, 1}, {2, 2}, {3, 3}], # diagonal up right
    [{1, -1}, {2, -2}, {3, -3}], # diagonal down righ
    [{-1, -1}, {-2, -2}, {-3, -3}], # diagonal down left
    [{-1, 1}, {-2, 2}, {-3, 3}], # diagonal up left
  ]
  @relative_vectors_mas [
    [{1, 1}, {2, 2}], # diagonal up right
    [{1, -1}, {2, -2}], # diagonal down righ
    [{-1, -1}, {-2, -2}], # diagonal down left
    [{-1, 1}, {-2, 2}], # diagonal up left
  ]

  def parse({:ok, data}) do
    String.split(data, "\n")
    |> Enum.map(fn x -> String.graphemes(x) end)
    |> indexed
  end

  def search_xmas(data) do
    search_xmas_part_1(data, data)
  end

  def search_x_mas(data) do
    search_xmas_part_2(data, data)
  end

  def search_xmas_part_1([{coordinate, "X"} | tail], data, words \\ 0) do
    words = deep_search(to_list(coordinate), @relative_vectors,  data, words)
    search_xmas_part_1(tail, data, words)
  end

  def search_xmas_part_1([_head | tail], data, words) do
    search_xmas_part_1(tail, data, words)
  end

  def search_xmas_part_1([], _, words) do
    words
  end


  def deep_search([x | [y | []]], [head | tail], full_data, words) do
    count_letters = word_search(x, y, head, @word, full_data)

    case count_letters do
      3 -> deep_search([x, y], tail, full_data, words + 1)
      _ -> deep_search([x, y], tail, full_data, words)
    end
  end

  def deep_search(_, [], _, words) do
    words
  end

  defp word_search(x, y, [{shift_x, shift_y} | tail], [next_letter | letters], full_data, count \\ 0) do
    key = to_atom(x + shift_x, y + shift_y)
    current_letter = Keyword.get(full_data, key)
    case current_letter do
      ^next_letter -> word_search(x, y, tail, letters, full_data, count + 1)
      nil -> word_search(x, y, [], [], full_data, 0)
      _ -> word_search(x, y, tail, letters, full_data, count)
    end
  end

  defp word_search(_x, _y, _, [], _full_data, count) do
    count
  end


  def search_xmas_part_2([{coordinate, "M"} | tail], full_data, searched \\ []) do
    s = search_mas(to_list(coordinate), full_data, searched)
    search_xmas_part_2(tail, full_data, searched ++ s)
  end

  def search_xmas_part_2([_head | tail], full_data, searched) do
    search_xmas_part_2(tail, full_data, searched)
  end

  def search_xmas_part_2([], _, searched) do
    searched |> Enum.frequencies() |> Enum.filter(
      fn {_, value} -> value >= 2 end
    )
    |> length
  end


  defp search_mas([x | [y | []]], full_data, searched) do
    search_by_vectors(x, y, @relative_vectors_mas, full_data)
  end

  defp search_by_vectors(x, y, [head | vectors], full_data, matched_a \\ []) do
    m = search_one_vector(x, y, head, @short_word, full_data)

    case length(m) do
      2 -> search_by_vectors(x, y, vectors, full_data, [Enum.at(m, 1) | matched_a])
      _ -> search_by_vectors(x, y, vectors, full_data, matched_a)
    end

  end

  defp search_by_vectors(_, _, [], _, matched) do
    matched
  end

  def search_one_vector(x, y, [{shift_x, shift_y} | tail], [char | offset], full_data, matched \\ []) do
    key = to_atom(x + shift_x, y + shift_y)
    current_char = Keyword.get(full_data, key)

    case current_char do
      ^char -> search_one_vector(x, y, tail, offset, full_data, [key | matched])
      _ -> search_one_vector(x, y, tail, [], full_data, [matched])
    end
  end

  def search_one_vector(_x, _y, _vectors, [], _full_data, matched) do
    matched
  end



  defp indexed(data) do
    Enum.with_index(data)
    |> Enum.map(
      fn {row, y} -> Enum.map(
        Enum.with_index(row),
        fn {char, x} -> {to_atom(x, y), char}end
      ) end
    )
    |> List.flatten
  end

  defp to_list(atom) do
    Atom.to_string(atom)
    |> String.split(":")
    |> Enum.map(&String.to_integer/1)
  end

  defp to_atom(x, y) do
    String.to_atom("#{x}:#{y}")
  end



end
