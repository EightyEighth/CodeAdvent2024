defmodule Advent.Day6 do
  @step %{
    up: [-1, 0],
    down: [1, 0],
    right: [0, 1],
    left: [0, -1]
  }

  def parse({:ok , data}) do
    data
    |> String.split("\n")
    |> Enum.map(fn sub ->
      sub
      |> String.graphemes()
      |> Enum.map(fn
        "." -> ""
        char -> char
      end)
    end)
  end

  def move(map) do
    current_postion = find_first_one_based(map, "^")
    [y, x] = current_postion
    data = try_step_forward(map, current_postion, :up, [{y, x, :up}])
    draw(map, data[:visited], current_postion)
    length(data[:visited]|> Enum.uniq_by(fn {y, x, _} -> {y, x} end))

  end

  def move2(map) do
    current_postion = find_first_one_based(map, "^")
    [y, x] = current_postion
    data = try_step_forward(map, current_postion, :up, [{y, x, :up}])
    detected_loops = try_detect_loop(map, current_postion, data[:visited], data[:loops])
    length(detected_loops)
  end

  def try_detect_loop(map, [y | [x | []]] = current_postion, [position | tail], loops) do
    new_map = set_abstruction(map, position)
    IO.inspect position
    IO.inspect length(tail)
    data = try_step_forward(new_map, current_postion, :up, [{y, x, :up}], loops)
    IO.inspect data
    try_detect_loop(map, current_postion, tail, loops ++ data[:loops])
  end

  def set_abstruction(map, {y, x, _}) do
    map
    |> Enum.with_index
    |> Enum.map(
      fn {row, current_y} ->
        if current_y == y do
          List.replace_at(row, x, "O")
        else
          row
        end
      end
    )
  end


  def find_first_one_based(nested_list, target) when is_list(nested_list) do
    nested_list
    |> Enum.with_index(0)
    |> Enum.reduce_while(nil, fn {sublist, row_index}, _acc ->
      case Enum.find_index(sublist, fn elem -> elem == target end) do
        nil ->
          {:cont, nil}
        col_index ->
          {:halt, [row_index, col_index]}
      end
    end)
  end

  def try_step_forward(map, [y | [x | []]], direction, visited \\ [], loop_detected \\ []) do

    [next_y, next_x] = next_coordinates(y, x, direction)
    next = map |> safe_at(next_y) |> safe_at(next_x)

    if length(loop_detected) >= 2 do
      try_step_forward(map, [], direction, visited, loop_detected)
    end

    case next do

      "" -> try_step_forward(map, [next_y, next_x], direction, [{next_y, next_x, direction} | visited], loop_detected)
      "^" -> try_step_forward(map, [next_y, next_x], direction, [{next_y, next_x, direction} | visited], loop_detected)
      "#" -> try_step_forward(map, [y, x], change_direction(direction), visited, loop_detected)
      "O" -> loop_detect(map, [x, y], next_y, next_x, change_direction(direction), visited, loop_detected)
      [] -> try_step_forward(map, [], direction, visited, loop_detected)
    end
  end

  def try_step_forward(_, [], _, visited, loop_detected) do
    %{visited: visited, loops: loop_detected}
  end

  def loop_detect(map, [y | [x | []]], next_y, next_x, direction, visited \\ [], loop_detected \\ []) do
    try_step_forward(map, [y, x], change_direction(direction), visited, [{next_y, next_x, direction} | loop_detected])
  end

  defp draw(map, [{y, x, d} | tail], start) do
    new_map = map
    |> Enum.with_index
    |> Enum.map(
      fn {row, current_y} ->
        if current_y == y do
          List.replace_at(row, x, draw_guard(d))
        else
          row
        end
      end
    )
    draw(new_map, tail, start)
  end


  defp draw(map, [], start) do
    IO.puts start
    map
    |> Enum.with_index
    |> Enum.map(
      fn {row, current_y} ->
        [y, x] = start
        if current_y == y do
          List.replace_at(row, x, "X")
        else
          row
        end
      end
    )
    |> grid_to_string
    |> IO.puts
  end

  defp draw_guard(direcrion) do
    case direcrion do
      :up -> "^"
      :down -> "v"
      :left -> "<"
      :right -> ">"
    end
  end

  def grid_to_string(grid) do
    grid
    |> Enum.map(&replace_empty_with_dot/1)    # Step 1: Replace "" with "."
    |> Enum.map(&join_row/1)                  # Step 2: Join row elements into a string
    |> Enum.join("\n")                        # Step 3: Join all rows with newline
  end

  defp replace_empty_with_dot(row) do
    Enum.map(row, fn
      "" -> "."
      cell -> cell
    end)
  end

  defp join_row(row) do
    Enum.join(row, "")
  end

  defp next_coordinates(y, x, direction) do
    [shift_y, shift_x] = @step[direction]
    next_x = x + shift_x
    next_y = y + shift_y

   [next_y, next_x]
  end

  def safe_at(list, index) when is_integer(index) and index >= 0 do
    Enum.at(list, index, [])
  end

  def safe_at(_list, _index), do: []


  def change_direction(current_direction) do
    case current_direction do
      :up -> :right
      :down -> :left
      :right -> :down
      :left -> :up
    end
  end
end
