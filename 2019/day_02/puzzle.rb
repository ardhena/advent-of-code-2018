require_relative '../intcode_computer/intcode_computer'

class Puzzle
  def initialize(input = nil)
    @input = input || File.readlines("input").map(&:strip).first.split(",").map(&:to_i)
  end

  def adjust_input(noun, verb)
    @input[1] = noun
    @input[2] = verb
    self
  end

  def calc_part_1
    IntcodeComputer.new(@input).run(0)
  end

  class << self
    def calc_part_2(expected_value)
      loop do
        output = Puzzle.new.adjust_input(self.generate_value(), self.generate_value()).calc_part_1()
        return 100 * output[1] + output[2] if expected_value == output[0]
      end
    end

    def generate_value
      (0..99).to_a.sample
    end
  end
end