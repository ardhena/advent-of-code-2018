defmodule Puzzle do
  def load_input do
    "input"
    |> File.read!()
    |> String.splitter("\n", trim: true)
  end

  @doc """
  Calculates resulting frequency after all frequency changes.

  ## Solution:

    iex> Puzzle.load_input() |> Puzzle.calc_part_1()
    543
  """
  def calc_part_1(input) do
    input
    |> Enum.map(&String.to_integer(&1))
    |> Enum.sum()
  end

  @doc """
  Loops through frequency changes until the same frequency is reached for the second time.

  ## Solution:

    iex> Puzzle.load_input() |> Puzzle.calc_part_2()
    {621, 2}
  """
  def calc_part_2(input) do
    input
    |> loop_and_find_double(%{result: 0, freq: %{}})
  end

  defp loop_and_find_double(data, acc) do
    case build_results_for_data(data, acc) do
      {_, _} = result -> result
      %{} = result -> loop_and_find_double(data, result)
    end
  end

  defp build_results_for_data(data, acc) do
    Enum.reduce(data, acc, fn
      _, {frequency_value, frequency_count} ->
        {frequency_value, frequency_count}

      number, %{result: acc, freq: freq} ->
        result = acc + String.to_integer(number)
        freq = Map.update(freq, result, 1, &(&1 + 1))

        case Map.get(freq, result) do
          2 -> {result, 2}
          _ -> %{result: result, freq: freq}
        end
    end)
  end
end
