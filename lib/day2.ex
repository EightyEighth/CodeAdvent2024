defmodule Advent.Day2 do
  def total_safe_reports(reports, state \\ 0, part \\ 1)

  def total_safe_reports([report | tail], state, part) do
    is_safe =
      case part do
        1 -> safe?(report)
        2 -> safe2?(report)
      end

    if not is_safe do
      IO.inspect(report, label: "Is not safe", charlists: :as_lists)
    end

    case is_safe do
      true -> total_safe_reports(tail, state + 1, part)
      _ -> total_safe_reports(tail, state, part)
    end
  end

  def total_safe_reports([], state, _), do: state

  def generate_tolerate_lists(report) do
    Enum.with_index(report)
    |> Enum.map(fn {_, index} -> List.delete_at(report, index) end)
  end

  def safe2?(report) do
    case safe?(report) do
      false -> report
      |> generate_tolerate_lists
      |> Enum.map(fn list -> safe?(list) end)
      |> Enum.any?
      true -> true
    end
  end

  def safe?(report) do
    direction = get_direction(report)

    report
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> valid_pair?(a, b, direction) end)
    |> Enum.all?
  end

  defp valid_pair?(a, b, :inc), do: a < b and (1 <= b - a and b - a <= 3)
  defp valid_pair?(a, b, :dec), do: a > b and (1 <= a - b and a - b <= 3)

  def get_direction(report) do
    [first, second | _] = report
    if first > second, do: :dec, else: :inc
  end

  def parse({:ok, data}) do
    data
    |> String.split("\n")
    |> Enum.map(&String.split/1)
    |> Enum.map(
      fn sublist -> Enum.map(sublist, fn x -> String.to_integer(x) end) end
    )
  end
end
