defmodule Puzzle do
  def load_input do
    "input"
    |> File.read!()
    |> String.trim()
  end

  @doc """
  Reacts whole polymer and calculates end length

  ## Solution:

    iex> Puzzle.load_input() |> Puzzle.calc_part_1()
    10450
  """
  def calc_part_1(input) do
    input
    |> react(nil, nil)
    |> length()
  end

  defp react(polymer, discard_unit_u, discard_unit_d) when is_binary(polymer),
    do: react(polymer, [], discard_unit_u, discard_unit_d)

  defp react(<<letter, rest_of_polymer::binary>>, reacted, discard_unit_d, discard_unit_u)
       when letter == discard_unit_u or letter == discard_unit_d,
       do: react(rest_of_polymer, reacted, discard_unit_u, discard_unit_d)

  defp react(
         <<letter1, rest_of_polymer::binary>>,
         [letter2 | reacted],
         discard_unit_d,
         discard_unit_u
       )
       when abs(letter1 - letter2) == 32,
       do: react(rest_of_polymer, reacted, discard_unit_d, discard_unit_u)

  defp react(<<letter, rest_of_polymer::binary>>, reacted, discard_unit_d, discard_unit_u),
    do: react(rest_of_polymer, [letter | reacted], discard_unit_d, discard_unit_u)

  defp react(<<>>, reacted, _discard_unit_d, _discard_unit_u), do: reacted

  @doc """
  Removes each unit from a polymer and reacts it. Finds the lowest length of the polymer without one unit.

  ## Solution:

    iex> Puzzle.load_input() |> Puzzle.calc_part_2()
    4624
  """
  def calc_part_2(input) do
    ?A..?Z
    |> Enum.map(fn unit ->
      input
      |> react(unit, unit + 32)
      |> length()
    end)
    |> Enum.min()
  end
end
