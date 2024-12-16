defmodule Advent do
  @files_path Path.expand("../files", __DIR__)
  alias Advent.Day1
  alias Advent.Day2
  alias Advent.Day3
  alias Advent.Day4
  alias Advent.Day5
  alias Advent.Day6

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

    IO.puts "Day 4 starting..."

    IO.puts "Part 1"
    Path.join(@files_path, "input4.1")
    |> File.read
    |> Day4.parse
    |> Day4.search_xmas
    |> IO.puts

    IO.puts "Part 2"
    Path.join(@files_path, "input4.1")
    |> File.read
    |> Day4.parse
    |> Day4.search_x_mas
    |> IO.puts

    IO.puts "Day 5 starting..."

    IO.puts "Part 1"
    Path.join(@files_path, "input5.1")
    |> File.read
    |> Day5.parse
    |> Day5.count_middle_bad_pages
    |> IO.inspect


    IO.puts "Part 2"
    Path.join(@files_path, "input5.1")
    |> File.read
    |> Day5.parse
    |> Day5.count_middle_correct_pages
    |> IO.puts


    IO.puts "Day 6 starring..."

    IO.puts "Part 1"

    Path.join(@files_path, "example6.1")
    |> File.read
    |> Day6.parse
    |> Day6.move
    |> IO.inspect


    IO.puts "Part 2"

    Path.join(@files_path, "example6.1")
    |> File.read
    |> Day6.parse
    |> Day6.move2
    |> IO.inspect

  end
end


Advent.run
