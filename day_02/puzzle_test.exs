Code.load_file("puzzle.exs", __DIR__)

ExUnit.start()

defmodule PuzzleTest do
  use ExUnit.Case

  describe "part one" do
    test "calculates checksum from input" do
      assert Puzzle.calc_part_1([
               "abcdef",
               "bababc",
               "abbcde",
               "abcccd",
               "aabcdd",
               "abcdee",
               "ababab"
             ]) == 12
    end

    test "calculates checksum from input file" do
      assert Puzzle.load_input() |> Puzzle.calc_part_1() == 6696
    end
  end

  describe "part two" do
    test "finds the common id from input" do
      assert Puzzle.calc_part_2(["abcde", "fghij", "klmno", "pqrst", "fguij", "axcye", "wvxyz"]) ==
               {{"fgij", 3}, ["fguij", "fghij"]}
    end

    test "finds the common id from input file" do
      assert Puzzle.load_input() |> Puzzle.calc_part_2() ==
               {{"bvnfawcnyoeyudzrpgslimtkj", 21},
                ["bvnfawcnyoeyudzrpgsldimtkj", "bvnfawcnyoeyudzrpgsleimtkj"]}
    end
  end
end
