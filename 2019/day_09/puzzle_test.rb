require 'minitest/autorun'
require_relative 'puzzle'

class PuzzleTest < Minitest::Test
  def test_calc_part_1
    # calculates examples
    assert_equal [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99], Puzzle.new([109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]).calc_part_1
    assert_equal [1219070632396864], Puzzle.new([1102,34915192,34915192,7,4,7,99,0]).calc_part_1
    assert_equal [1125899906842624], Puzzle.new([104,1125899906842624,99]).calc_part_1

    # calculates from input file
    assert_equal [3989758265], Puzzle.new().calc_part_1(1)
  end

  def test_calc_part_2
    # calculates from input file
    assert_equal [76791], Puzzle.new().calc_part_1(2)
  end
end