class Puzzle
  def initialize(input = nil)
    @input = input || File.readlines("input").map(&:strip)
  end

  def calc_part_1
    @input
  end

  def calc_part_2
    @input
  end
end