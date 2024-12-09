defmodule Advent do
  @files_path Path.expand("../files", __DIR__)
  alias Advent.Day1
  alias Advent.Day2
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
  end
end


Advent.run
