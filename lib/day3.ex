defmodule Advent.Day3 do
  def parse1({:ok, data}) do
    pattern = ~r/mul\((\d+),(\d+)\)/

    Regex.scan(pattern, data)
  end

  def parse2({:ok, data}) do
    pattern = ~r/(mul\((\d+),(\d+)\)|(do|don't)\(\))/

    Regex.scan(pattern, data)
  end

  def calculate_result(result) do
    result
    |> Enum.map(fn [_, a, b] -> calculate(a, b, :enabled) end)
    |> Enum.sum
  end

  def calculate_result_with_switch([[func, _, a, b | _] | tail], state \\ :enabled, sum \\ 0) do
    cond do
      String.contains?(func, "do()") -> calculate_result_with_switch(tail, :enabled, sum)
      String.contains?(func, "don't()") -> calculate_result_with_switch(tail, :disabled, sum)
      true -> calculate_result_with_switch(tail, state, sum + calculate(a, b, state))
    end

  end

  def calculate_result_with_switch([], _, sum) do
    sum
  end

  defp calculate(a, b, :enabled) do
    String.to_integer(a) * String.to_integer(b)
  end

  defp calculate(_, _, :disabled) do
    0
  end

end
