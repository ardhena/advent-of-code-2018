require_relative '../intcode_computer/intcode_computer'

class Puzzle
  def initialize(input = nil)
    @input = input || File.readlines("input").map(&:strip).first.split(",").map(&:to_i)
  end

  def calc_part_1(input_value = 1)
    program = IntcodeComputer.new(@input)
    program.run(input_value)
    program.output_values
  end
end