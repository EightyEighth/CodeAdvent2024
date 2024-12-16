defmodule Advent.Day7 do

  @operators1 ["+", "*"]
  @operators2 ["+", "*", "||"]

  def get_operator_combinations_1(length) do
    Enum.reduce(1..length, @operators1, fn _, acc ->
      for x <- acc, y <- @operators1, do: List.wrap(x) ++ [y]
    end)
  end

  def get_operator_combinations_2(n) when is_integer(n) and n > 0 do
    1..n
    |> Enum.reduce([[]], fn _, acc ->
      for combo <- acc, op <- @operators2, do: combo ++ [op]
    end)
  end


  def parse({:ok, data}) do
    String.split(data, "\n")
    |> Enum.map(
      fn line ->
        [result, string_numbers] = String.split(line, ":")
        %{
          result: String.to_integer(result),
          numbers: Enum.map(String.split(string_numbers), fn x -> String.to_integer(x) end)
        }
      end
    )
  end

  def get_result(line) do
    expected_result = line[:result]
    numbers = line[:numbers]

    # Генеруємо комбінації операторів ліниво
    get_operator_combinations_2(length(numbers) - 1)
    |> Stream.map(
        fn operators ->
          calculate(operators, numbers)
        end) # Обчислення результату
    |> Stream.filter(fn result -> result == expected_result end)    # Фільтруємо правильні
    |> Enum.take(1)                                                 # Беремо перший результат
    |> List.first()
  end

  def corection2(map) do
    # Використання Task.async_stream для обмеження паралелізму
    map
    |> Task.async_stream(fn line -> get_result(line) end,
         max_concurrency: System.schedulers_online(), # Ліміт на кількість потоків
         timeout: 5000                                # Таймаут для кожного завдання
       )
    |> Enum.reduce(0, fn
      {:ok, result}, acc when is_number(result) -> acc + result
      _, acc -> acc # Ігноруємо помилки або nil
    end)
  end

  def corection([head | tail], correct_sums \\ []) do
    expected_result = head[:result]
    numbers = head[:numbers]
    combination_streams = get_operator_combinations_1(length(numbers))

    result =
    Enum.map(
      combination_streams,
      fn operators ->
        calculate(operators, numbers)
    end)
    |> List.flatten
    |> Enum.filter(fn x -> x == expected_result end)
    |> List.first

    case result do
      nil -> corection(tail, correct_sums)
      _ -> corection(tail, [result | correct_sums])
    end
  end
  def corection([], correct_sums), do: correct_sums |> Enum.sum


  def operate(a, b, operator) do
    case operator do
      "+" -> a + b
      "*" -> a * b
      "||" -> String.to_integer(Integer.to_string(a) <> Integer.to_string(b))
    end
  end

  def calculate([operator | operators], [a | [b | tail]]) do
    result = operate(a, b, operator)
    calculate(operators, [result | tail])
  end
  def calculate(_, [result | []]), do: result
end
