Code.load_file("puzzle.exs", __DIR__)

ExUnit.start()

defmodule PuzzleTest do
  use ExUnit.Case

  describe "part one" do
    test "calculates resulting frequency from input" do
      assert Puzzle.calc_part_1(["+1", "-2", "+3", "+1"]) == 3
      assert Puzzle.calc_part_1(["+1", "+1", "+1"]) == 3
      assert Puzzle.calc_part_1(["+1", "+1", "-2"]) == 0
      assert Puzzle.calc_part_1(["-1", "-2", "-3"]) == -6
    end

    test "calculates resulting frequency from input file" do
      assert Puzzle.load_input() |> Puzzle.calc_part_1() == 543
    end
  end

  describe "part two" do
    test "calculates resulting frequency from input" do
      assert Puzzle.calc_part_2(["+1", "-2", "+3", "+1", "+1", "-2"]) == {2, 2}

      assert Puzzle.calc_part_2(["+3", "+3", "+4", "-2", "-4", "+3", "+3", "+4", "-2", "-4"]) ==
               {10, 2}

      assert Puzzle.calc_part_2([
               "-6",
               "+3",
               "+8",
               "+5",
               "-6",
               "-6",
               "+3",
               "+8",
               "+5",
               "-6",
               "-6",
               "+3",
               "+8",
               "+5",
               "-6"
             ]) == {5, 2}

      assert Puzzle.calc_part_2([
               "+7",
               "+7",
               "-2",
               "-7",
               "-4",
               "+7",
               "+7",
               "-2",
               "-7",
               "-4",
               "+7",
               "+7",
               "-2",
               "-7",
               "-4"
             ]) == {14, 2}
    end

    test "calculates resulting frequency from input file" do
      assert Puzzle.load_input() |> Puzzle.calc_part_2() == {621, 2}
    end
  end
end
