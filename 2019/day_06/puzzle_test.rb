require 'minitest/autorun'
require_relative 'puzzle'

class PuzzleTest < Minitest::Test
  def test_calc_part_1
    # calculates examples
    assert_equal 42, Puzzle.new(["COM)B","B)C","C)D","D)E","E)F","B)G","G)H","D)I","E)J","J)K","K)L"]).prepare_orbits().calc_part_1()
    assert_equal 42, Puzzle.new(["C)D","COM)B","B)C","G)H","K)L","E)J","D)E","E)F","B)G","D)I","J)K"]).prepare_orbits().calc_part_1()

    # calculates from input file
    assert_equal 117672, Puzzle.new().prepare_orbits().calc_part_1()
  end

  def test_calc_part_2
    # calculates examples
    assert_equal 4, Puzzle.new(["COM)B","B)C","C)D","D)E","E)F","B)G","G)H","D)I","E)J","J)K","K)L","K)YOU","I)SAN"]).prepare_orbits().calc_part_2("YOU", "SAN")

    # calculates from input file
    assert_equal 277, Puzzle.new().prepare_orbits().calc_part_2("YOU", "SAN")
  end
end
