defmodule Parser do
  def read_example(example) do
    File.read!(example)
  end
end
