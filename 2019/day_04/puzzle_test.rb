require 'minitest/autorun'
require_relative 'puzzle'

class PuzzleTest < Minitest::Test
  def test_calc_part_1
    # calculates examples
    assert_equal 2, Puzzle.new([111110, 111112]).calc_part_1()
    assert_equal 1, Puzzle.new([111111, 111111]).calc_part_1()
    assert_equal 0, Puzzle.new([223450, 223450]).calc_part_1()
    assert_equal 0, Puzzle.new([123789, 123789]).calc_part_1()

    # calculates from input file
    assert_equal 1625, Puzzle.new().calc_part_1()
  end

  def test_calc_part_2
    # calculates examples
    assert_equal 1, Puzzle.new([112233, 112233]).calc_part_2()
    assert_equal 0, Puzzle.new([123444, 123444]).calc_part_2()
    assert_equal 1, Puzzle.new([111122, 111122]).calc_part_2()

    # calculates from input file
    assert_equal 1111, Puzzle.new().calc_part_2()
  end
end