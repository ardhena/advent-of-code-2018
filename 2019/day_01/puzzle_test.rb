require 'minitest/autorun'
require_relative 'puzzle'

class PuzzleTest < Minitest::Test
  def test_calc_part_1
    # calculates examples
    assert_equal 2, Puzzle.new([12]).calc_part_1()
    assert_equal 2, Puzzle.new([14]).calc_part_1()
    assert_equal 654, Puzzle.new([1969]).calc_part_1()
    assert_equal 33583, Puzzle.new([100756]).calc_part_1()

    # calculates from input file
    assert_equal 3412531, Puzzle.new().calc_part_1()
  end

	def test_calc_part_2
    # calculates examples
    assert_equal 2, Puzzle.new([12]).calc_part_2()
    assert_equal 2, Puzzle.new([14]).calc_part_2()
    assert_equal 966, Puzzle.new([1969]).calc_part_2()
    assert_equal 50346, Puzzle.new([100756]).calc_part_2()

    # calculates from input file
    assert_equal 5115927, Puzzle.new().calc_part_2()
	end
end