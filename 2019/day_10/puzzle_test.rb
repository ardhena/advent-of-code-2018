require 'minitest/autorun'
require_relative 'puzzle'

class PuzzleTest < Minitest::Test
  def test_calc_part_1
    # calculates examples
    assert_equal(
      {coords: [3, 4], asteroids: 8}, 
      Puzzle.new([".#..#",".....","#####","....#","...##"]).calc_part_1
    )

    assert_equal(
      {coords: [5,8], asteroids: 33}, 
      Puzzle.new(["......#.#.","#..#.#....","..#######.",".#.#.###..",".#..#.....","..#....#.#","#..#....#.",".##.#..###","##...#..#.",".#....####"]).calc_part_1
    )

    assert_equal(
      {coords: [1,2], asteroids: 35}, 
      Puzzle.new(["#.#...#.#.",".###....#.",".#....#...","##.#.#.#.#","....#.#.#.",".##..###.#","..#...##..","..##....##","......#...",".####.###."]).calc_part_1
    )

    assert_equal(
      {coords: [6,3], asteroids: 41}, 
      Puzzle.new([".#..#..###","####.###.#","....###.#.","..###.##.#","##.##.#.#.","....###..#","..#.#..#.#","#..#.#.###",".##...##.#",".....#.#.."]).calc_part_1
    )

    assert_equal(
      {coords: [11,13], asteroids: 210}, 
      Puzzle.new([".#..##.###...#######","##.############..##.",".#.######.########.#",".###.#######.####.#.","#####.##.#.##.###.##","..#####..#.#########","####################","#.####....###.#.#.##","##.#################","#####.##.###..####..","..######..##.#######","####.##.####...##..#",".#####..#.######.###","##...#.##########...","#.##########.#######",".####.#.###.###.#.##","....##.##.###..#####",".#.#.###########.###","#.#.#.#####.####.###","###.##.####.##.#..##"]).calc_part_1
    )

    # calculates from input file
    assert_equal({coords: [22, 19], asteroids: 282}, Puzzle.new().calc_part_1())
  end

  def test_calc_part_2
    # calculates examples
    assert_equal(
      [[8,1],[9,0],[9,1],[10,0],[9,2],[11,1],[12,1],[11,2],[15,1],[12,2],[13,2],[14,2],[15,2],[12,3],[16,4],[15,4],[10,4],[4,4],[2,4],[2,3],[0,2],[1,2],[0,1],[1,1],[5,2],[1,0],[5,1],[6,1],[6,0],[7,0],[8,0],[10,1],[14,0],[16,1],[13,3],[14,3]],
      Puzzle.new([".#....#####...#..","##...##.#####..##","##...#...#.#####.","..#.....#...###..","..#.#.....#....##"])
        .calc_part_2(8, 3)
    )

    vaporized_asteroids = 
      Puzzle.new([".#..##.###...#######","##.############..##.",".#.######.########.#",".###.#######.####.#.","#####.##.#.##.###.##","..#####..#.#########","####################","#.####....###.#.#.##","##.#################","#####.##.###..####..","..######..##.#######","####.##.####...##..#",".#####..#.######.###","##...#.##########...","#.##########.#######",".####.#.###.###.#.##","....##.##.###..#####",".#.#.###########.###","#.#.#.#####.####.###","###.##.####.##.#..##"])
        .calc_part_2(11, 13)

    assert_equal [11,12], vaporized_asteroids[0]
    assert_equal [12,1], vaporized_asteroids[1]
    assert_equal [12,2], vaporized_asteroids[2]
    assert_equal [12,8], vaporized_asteroids[9]
    assert_equal [16,0], vaporized_asteroids[19]
    assert_equal [16,9], vaporized_asteroids[49]
    assert_equal [10,16], vaporized_asteroids[99]
    assert_equal [9,6], vaporized_asteroids[198]
    assert_equal [8,2], vaporized_asteroids[199]
    assert_equal [10,9], vaporized_asteroids[200]
    assert_equal [11,1], vaporized_asteroids[298]

    # calculates from input file
    puzzle = Puzzle.new()
    station_x, station_y = puzzle.calc_part_1[:coords]

    vaporized_asteroids = puzzle.calc_part_2(station_x, station_y)
    assert_equal [10,8], vaporized_asteroids[199]
  end
end