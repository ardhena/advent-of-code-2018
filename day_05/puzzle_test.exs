Code.load_file("puzzle.exs", __DIR__)

ExUnit.start()

defmodule PuzzleTest do
  use ExUnit.Case

  describe "part one" do
    test "calculates polymer length after reactions from input" do
      assert Puzzle.calc_part_1("dabAcCaCBAcCcaDA") == 10
    end

    test "calculates polymer length after reactions from input file" do
      assert Puzzle.load_input() |> Puzzle.calc_part_1() == 10450
    end
  end

  describe "part two" do
    test "calculates minimal polymer length after one unit removal reactions from input" do
      assert Puzzle.calc_part_2("dabAcCaCBAcCcaDA") == 4
    end

    test "calculates minimal polymer length after one unit removal reactions from input file" do
      assert Puzzle.load_input() |> Puzzle.calc_part_2() == 4624
    end
  end
end
