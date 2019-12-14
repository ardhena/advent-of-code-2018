require 'minitest/autorun'
require_relative 'puzzle'

class PuzzleTest < Minitest::Test
  def test_calc_part_1
    # calculates from input file
    assert_equal 357, Puzzle.new.calc_part_1
  end

  def test_calc_part_2
    # calculates from input file
    assert_equal 17468, Puzzle.new.calc_part_2
  end
end