Code.load_file("puzzle.exs", __DIR__)

ExUnit.start()

defmodule PuzzleTest do
  use ExUnit.Case

  describe "part one" do
    test "calculates ... from input" do
      # assert Puzzle.calc_part_1(input) == result
    end

    test "calculates ... from input file" do
      # assert Puzzle.load_input() |> Puzzle.calc_part_1() == result
    end
  end

  describe "part two" do
    test "calculates ... from input" do
      # assert Puzzle.calc_part_2(input) == result
    end

    test "calculates ... from input file" do
      # assert Puzzle.load_input() |> Puzzle.calc_part_2() == result
    end
  end
end
