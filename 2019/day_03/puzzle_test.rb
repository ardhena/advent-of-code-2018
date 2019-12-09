require 'minitest/autorun'
require_relative 'puzzle'
require 'pry'

class PuzzleTest < Minitest::Test
  def test_calc_part_1
    # calculates examples
    assert_equal 6, Puzzle.new(["R8,U5,L5,D3", "U7,R6,D4,L4"]).calc_part_1()
    assert_equal 159, Puzzle.new(["R75,D30,R83,U83,L12,D49,R71,U7,L72", "U62,R66,U55,R34,D71,R55,D58,R83"]).calc_part_1()
    assert_equal 135, Puzzle.new(["R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51", "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"]).calc_part_1()

    # calculates from input file
    assert_equal 280, Puzzle.new().calc_part_1()
  end

  def test_calc_part_2
    # calculates examples
    assert_equal 30, Puzzle.new(["R8,U5,L5,D3", "U7,R6,D4,L4"]).calc_part_2()
    assert_equal 610, Puzzle.new(["R75,D30,R83,U83,L12,D49,R71,U7,L72", "U62,R66,U55,R34,D71,R55,D58,R83"]).calc_part_2()
    assert_equal 410, Puzzle.new(["R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51", "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"]).calc_part_2()

    # calculates from input file
    assert_equal 10554, Puzzle.new().calc_part_2()
  end
end
