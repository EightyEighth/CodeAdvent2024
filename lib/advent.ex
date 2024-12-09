defmodule Advent do
  @files_path Path.expand("../files", __DIR__)
  alias Advent.Day1
  alias Advent.Day2
  alias Advent.Day3
  @moduledoc """
  Documentation for `Advent`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Advent.hello()
      :world

  """
  def run do
    IO.puts "Day 1 starting..."
    list = Path.join(@files_path, "input1")
    |> File.read
    |> Day1.parse

    IO.puts "Part 1"
    list
    |> Day1.shearch_distace
    |> IO.puts

    IO.puts "Part 2"
    list
    |> Day1.total_simmilarity_score
    |> IO.puts

    IO.puts "Day 1 finished!"

    IO.puts "Day 2 starting..."
    list = Path.join(@files_path, "input2")
      |> File.read
      |> Day2.parse


    IO.puts "Part 1"
    list
    |> Day2.total_safe_reports(0, 1)
    |> IO.puts

    IO.puts "Part 2"
    list
    |> Day2.total_safe_reports(0, 2)
    |> IO.puts

    IO.puts "Day 2 finished!"

    IO.puts "Day 3 starting..."

    IO.puts "Part 1"
    Path.join(@files_path, "input3")
    |> File.read
    |> Day3.parse1
    |> Day3.calculate_result
    |> IO.puts

    IO.puts "Part 2"
    Path.join(@files_path, "input3")
    |> File.read
    |> Day3.parse2
    |> Day3.calculate_result_with_switch
    |> IO.puts
  end
end


Advent.run
