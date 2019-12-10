require 'minitest/autorun'
require_relative 'puzzle'

class PuzzleTest < Minitest::Test
  def test_calc_part_1
    # calculates from input file
    assert_equal [0, 0, 0, 0, 0, 0, 0, 0, 0, 9025675], Puzzle.new().calc_part_1()
  end

  def test_calc_part_2
    # calculates examples
    assert_equal [1], Puzzle.new([3,9,8,9,10,9,4,9,99,-1,8]).calc_part_1(8)
    assert_equal [1], Puzzle.new([3,9,7,9,10,9,4,9,99,-1,8]).calc_part_1(7)
    assert_equal [1], Puzzle.new([3,3,1108,-1,8,3,4,3,99]).calc_part_1(8)
    assert_equal [1], Puzzle.new([3,3,1107,-1,8,3,4,3,99]).calc_part_1(7)

    assert_equal [0], Puzzle.new([3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9]).calc_part_1(0)
    assert_equal [0], Puzzle.new([3,3,1105,-1,9,1101,0,0,12,4,12,99,1]).calc_part_1(0)

    input = [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99]
    assert_equal [999], Puzzle.new(input).calc_part_1(5)
    assert_equal [1000], Puzzle.new(input).calc_part_1(8)
    assert_equal [1001], Puzzle.new(input).calc_part_1(12)

    # calculates from input file
    assert_equal [11981754], Puzzle.new().calc_part_1(5)
  end
end