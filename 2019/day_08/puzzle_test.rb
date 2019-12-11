require 'minitest/autorun'
require_relative 'puzzle'

class PuzzleTest < Minitest::Test
  def test_calc_part_1
    # calculates from input file
    assert_equal 1088, Puzzle.new().calc_part_1(25, 6)
  end

  def test_calc_part_2
    # calculates examples
    assert_equal "0110", Puzzle.new("0222112222120000").calc_part_2(2, 2)

    # calculates from input file
    assert_equal "100000110010001100101110010000100101000110010100101000010000010101111011100100001011000100100101001010000100100010010010100101111001110001001001011100", Puzzle.new().calc_part_2(25, 6)
  end
end