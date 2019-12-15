defmodule Puzzle do
  def load_input do
    "input"
    |> File.read!()
    |> String.splitter("\n", trim: true)
  end

  @doc """
  ...

  ## Solution:

    iex> Puzzle.load_input() |> Puzzle.calc_part_1()
    ...
  """
  def calc_part_1(input) do
    input
    # |> ...
  end

  @doc """
  ...

  ## Solution:

    iex> Puzzle.load_input() |> Puzzle.calc_part_2()
    ...
  """
  def calc_part_2(input) do
    input
    # |> ...
  end
end
