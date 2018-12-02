defmodule Puzzle do
  def load_input do
    "input"
    |> File.read!()
    |> String.splitter("\n", trim: true)
  end

  @doc """
  Calculates checksum for list of box IDs, based on the formula: y * x, where y is a number
  of box IDs with exactly the same two characters and x is a number of box IDs with exactly
  the same three characters.

  ## Solution:

    iex> Puzzle.load_input() |> Puzzle.calc_part_1()
    6696
  """
  def calc_part_1(input) do
    input
    |> Enum.reduce(%{two: 0, three: 0}, fn box_id, %{two: two, three: three} ->
      case number_of_same_letters(box_id) do
        {new_two, new_three} -> %{two: two + new_two, three: three + new_three}
      end
    end)
    |> Enum.reduce(1, fn {_k, v}, acc -> acc * v end)
  end

  defp number_of_same_letters(string) do
    string
    |> String.graphemes()
    |> Enum.reduce(%{}, fn char, acc -> Map.put(acc, char, (acc[char] || 0) + 1) end)
    |> Enum.reduce({0, 0}, fn
      {_, 2}, {1, three} -> {1, three}
      {_, 3}, {two, 1} -> {two, 1}
      {_, 2}, {two, three} -> {two + 1, three}
      {_, 3}, {two, three} -> {two, three + 1}
      {_, _}, {two, three} -> {two, three}
    end)
  end

  @doc """
  Finds the common ID for the two closest box IDs (that differ only by one character at the same
  index).

  ## Solution:

    iex> Puzzle.load_input() |> Puzzle.calc_part_2()
    {{"bvnfawcnyoeyudzrpgslimtkj", 21}, ["bvnfawcnyoeyudzrpgsldimtkj", "bvnfawcnyoeyudzrpgsleimtkj"]}
  """
  def calc_part_2(input) do
    input
    |> Enum.map(fn box_id -> {box_id, create_variants_without_one_letter(box_id)} end)
    |> Enum.reduce(%{}, fn {box_id, variants}, acc ->
      add_variants_with_box_id(box_id, variants, acc)
    end)
    |> Enum.find(fn {_variant_id, box_ids} -> length(box_ids) > 1 end)
  end

  defp add_variants_with_box_id(box_id, variants, acc) do
    Enum.reduce(variants, acc, fn variant_id, acc ->
      case acc[variant_id] do
        nil -> Map.put(acc, variant_id, [box_id])
        box_ids -> %{acc | variant_id => [box_id | box_ids]}
      end
    end)
  end

  defp create_variants_without_one_letter(box_id) do
    letters = box_id |> String.graphemes()

    1..length(letters)
    |> Enum.map(fn index ->
      {List.delete_at(letters, index - 1) |> Enum.join(""), index}
    end)
  end
end
