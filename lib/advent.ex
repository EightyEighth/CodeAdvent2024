defmodule Advent do
  @files_path Path.expand("../files", __DIR__)
  alias Advent.Day1
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
  end
end


Advent.run
