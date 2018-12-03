Code.load_file("puzzle.exs", __DIR__)

ExUnit.start()

defmodule PuzzleTest do
  use ExUnit.Case

  describe "part one" do
    test "calculates shared claims from input" do
      assert Puzzle.calc_part_1(["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"]) == 4
    end

    test "calculates shared claims from input file" do
      assert Puzzle.load_input() |> Puzzle.calc_part_1() == 117_948
    end
  end

  describe "part two" do
    test "calculates ... from input" do
      assert Puzzle.calc_part_2(["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"]) == [
               {"3", %{claims: 4, inches_square: 4}}
             ]
    end

    test "calculates ... from input file" do
      assert Puzzle.load_input() |> Puzzle.calc_part_2() == [
               {"567", %{claims: 437, inches_square: 437}}
             ]
    end
  end
end
