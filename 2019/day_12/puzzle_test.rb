require 'minitest/autorun'
require_relative 'puzzle'

class PuzzleTest < Minitest::Test
  def test_calc_part_1
    # calculates examples
    assert_equal(
      179, 
      Puzzle.new(["<x=-1, y=0, z=2>","<x=2, y=-10, z=-7>","<x=4, y=-8, z=8>","<x=3, y=5, z=-1>"])
            .calc_part_1(10).last
    )

    assert_equal(
      1940,
      Puzzle.new(["<x=-8, y=-10, z=0>","<x=5, y=5, z=10>","<x=2, y=-7, z=3>","<x=9, y=-8, z=-3>"])
            .calc_part_1(100).last
    )

    # calculates from input file
    assert_equal 12466, Puzzle.new.calc_part_1(1000).last
  end

  def test_calc_part_2
    # calculates examples
    assert_equal(
      2772,
      Puzzle.new(["<x=-1, y=0, z=2>","<x=2, y=-10, z=-7>","<x=4, y=-8, z=8>","<x=3, y=5, z=-1>"])
            .calc_part_2
    )

    assert_equal(
      4686774924,
      Puzzle.new(["<x=-8, y=-10, z=0>","<x=5, y=5, z=10>","<x=2, y=-7, z=3>","<x=9, y=-8, z=-3>"])
            .calc_part_2
    )

    # calculates from input file
    assert_equal 360689156787864, Puzzle.new.calc_part_2
  end
end