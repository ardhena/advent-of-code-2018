require 'minitest/autorun'
require_relative 'puzzle'

class PuzzleTest < Minitest::Test
  def test_calc_part_1
    # calculates examples
    assert_equal [3500,9,10,70,2,3,11,0,99,30,40,50], Puzzle.new([1,9,10,3,2,3,11,0,99,30,40,50]).calc_part_1()
    assert_equal [2,0,0,0,99], Puzzle.new([1,0,0,0,99]).calc_part_1()
    assert_equal [2,3,0,6,99], Puzzle.new([2,3,0,3,99]).calc_part_1()
    assert_equal [2,4,4,5,99,9801], Puzzle.new([2,4,4,5,99,0]).calc_part_1()
    assert_equal [30,1,1,4,2,5,6,0,99], Puzzle.new([1,1,1,4,99,5,6,0,99]).calc_part_1()

    # calculates from input file
    assert_equal 3267740, Puzzle.new().adjust_input(12, 2).calc_part_1().first
  end

  def test_calc_part_2
    # calculates from input file
    assert_equal 7870, Puzzle.calc_part_2(19690720)
  end
end