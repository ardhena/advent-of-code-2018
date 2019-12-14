require 'minitest/autorun'
require_relative 'puzzle'

class PuzzleTest < Minitest::Test
  def test_calc_part_1
    # calculates from input file
    assert_equal 2056, Puzzle.new().calc_part_1()
  end

  def test_calc_part_2
    # calculates from input file
    assert_equal(
      ["xx..xx.xxxx...xx....x...xxxx..x....x...xxxx", 
       "x.xx.x.xxxx.xx.x.xxxx.xx.xxxx.xxxx.x.xx.xxx", 
       "x.xxxx.xxxx...xx...xx.xx.xxxx.xxx.xx.xx.xxx", 
       "x.x..x.xxxx.xx.x.xxxx...xxxxx.xx.xxx...xxxx", 
       "x.xx.x.xxxx.xx.x.xxxx.xxxx.xx.x.xxxx.xxxxxx", 
       "xx...x....x...xx....x.xxxxx..xx....x.xxxxxx"], 
      Puzzle.new().calc_part_2()
    )
  end
end
