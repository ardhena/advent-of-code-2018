defmodule Puzzle do
  def load_input do
    "input"
    |> File.read!()
    |> String.splitter("\n", trim: true)
  end

  @doc """
  Calculates how many inches square have multiple claims.

  ## Solution:

    iex> Puzzle.load_input() |> Puzzle.calc_part_1()
    117_948
  """
  def calc_part_1(input) do
    input
    |> Enum.map(&parse_rectangle_details(&1))
    |> Enum.reduce(%{}, fn rectangle_details, acc ->
      rectangle_details
      |> build_fabric_claim()
      |> Enum.reduce(acc, fn {coords, _rectangle_details}, ac ->
        Map.update(ac, coords, 1, &(&1 + 1))
      end)
    end)
    |> Enum.filter(fn {_coords, claims} -> claims > 1 end)
    |> length()
  end

  defp parse_rectangle_details(raw) do
    [id, _, coords, size] = String.split(raw, " ")
    [_, id] = String.split(id, "#")
    [coords, _] = String.split(coords, ":")
    [from_left, from_top] = String.split(coords, ",")
    [width, height] = String.split(size, "x")

    %{
      id: id,
      from_top: String.to_integer(from_top),
      from_left: String.to_integer(from_left),
      width: String.to_integer(width),
      height: String.to_integer(height),
      inches_square: String.to_integer(width) * String.to_integer(height)
    }
  end

  defp build_fabric_claim(
         %{from_top: from_top, from_left: from_left, width: width, height: height} =
           rectangle_details
       ) do
    (from_left + 1)..(from_left + width)
    |> Enum.flat_map(fn i ->
      (from_top + 1)..(from_top + height)
      |> Enum.map(fn j ->
        {{i, j}, rectangle_details}
      end)
    end)
  end

  @doc """
  Finds an ID of rectangle that has no other claims for every square inch

  ## Solution:

    iex> Puzzle.load_input() |> Puzzle.calc_part_2()
    {"567", %{claims: 437, inches_square: 437}}
  """
  def calc_part_2(input) do
    input
    |> Enum.map(&parse_rectangle_details(&1))
    |> Enum.reduce(%{}, fn rectangle_details, acc ->
      rectangle_details
      |> build_fabric_claim()
      |> Enum.reduce(acc, fn {coords, rectangle_details}, ac ->
        Map.update(ac, coords, [rectangle_details], &(&1 ++ [rectangle_details]))
      end)
    end)
    |> Enum.filter(fn {_coords, rectangle_details} -> length(rectangle_details) == 1 end)
    |> Enum.reduce(%{}, fn {_coords, [rectangle_details]}, acc ->
      update_claims_for_inch(rectangle_details, acc)
    end)
    |> filter_single_claimed_rectangles()
  end

  defp update_claims_for_inch(%{id: id, inches_square: inches_square}, acc) do
    Map.update(acc, id, %{inches_square: inches_square, claims: 1}, fn %{claims: claims} = map ->
      %{map | claims: claims + 1}
    end)
  end

  defp filter_single_claimed_rectangles(data) do
    Enum.filter(data, fn {_id, %{inches_square: inches_square, claims: claims}} ->
      inches_square == claims
    end)
  end
end
