defmodule Advent.Day5 do
  def parse({:ok, data}) do
    [rules, pages] = String.split(data, "\n\n")

    rules = rules
      |> String.split("\n")
      |> Enum.map(fn rule -> String.split(rule, "|") end)
      |> Enum.group_by(fn [k, _v] -> k end, fn [_k, v] -> v end)

    pages = String.split(pages, "\n")
    |> Enum.map(fn str -> String.split(str, ",") end)

    {rules, pages}
  end

  def count_middle_bad_pages({rules , pages}) do
    find_bad_rows(rules, pages)
    |> Enum.map(
      fn row -> String.to_integer(Enum.at(row, round(length(row) / 2 - 1))) end
    )
    |> Enum.sum

  end

  def count_middle_correct_pages({rules, pages}) do
    bad_rows = find_bad_rows(rules, pages)
    correct_ordering(rules, bad_rows)
    |> Enum.map(
      fn row -> String.to_integer(Enum.at(row, round(length(row) / 2 - 1))) end
    )
    |> Enum.sum
  end

  def correct_ordering(rules, [row | rows], corrected_rows \\ []) do
    correct_row = correct_pages_ordering(rules, row)
    correct_ordering(rules, rows, [correct_row | corrected_rows])
  end

  def correct_ordering(_, [], corrected_rows) do
    corrected_rows
  end

  def correct_pages_ordering(rules, [page | pages], correct_row \\ []) do
    pages_after = Map.get(rules, page, [])
    if Enum.empty?(correct_row) do
      correct_pages_ordering(rules, pages, [page | correct_row])
    else
      list = Enum.map(
        correct_row,
        fn correct_page -> Enum.member?(pages_after, correct_page) end
      )
      index = Enum.find_index(list, fn x -> x == true end)

      if index == nil do
        correct_pages_ordering(rules, pages, correct_row ++ [page])
      else
        correct_pages_ordering(rules, pages, List.insert_at(correct_row, index, page))
      end
    end

end

  def correct_pages_ordering(_rules, [], correct_row) do
    correct_row
  end


  def find_bad_rows(rules, [row | tail], bad_rows \\ []) do
    result = check_row(rules, row, [])

    if Enum.empty?(result) do
      find_bad_rows(rules, tail, bad_rows)
    else
      find_bad_rows(rules, tail, [row | bad_rows])
    end
  end

  def find_bad_rows(_, [], bad_rows) do
    bad_rows
  end

  def check_row(rules, [page | tail], bad_pages \\ [], checked \\ []) do
    cond do
      length(checked) == 0 -> check_row(rules, tail, bad_pages, [page | checked])
      true ->
         has_bad_pages = Enum.map(
          checked,
          fn checked_element -> Enum.member?(Map.get(rules, page, []), checked_element) end
        ) |> Enum.any?

        case has_bad_pages do
          true -> check_row(rules, tail, [page | bad_pages], [page | checked])
          false -> check_row(rules, tail, bad_pages, [page | checked])
        end
    end

  end

  def check_row(_rules, [], bad_pages, _checked) do
    bad_pages
  end


end
