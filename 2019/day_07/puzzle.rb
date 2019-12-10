require_relative '../intcode_computer/intcode_computer'

class Puzzle
  PHASE_SETTING_1 = 0..4
  PHASE_SETTING_2 = 5..9

  def initialize(input = nil)
    @input = input || File.readlines("input").map(&:strip).first.split(",").map(&:to_i)
  end

  def calc_part_1
    PHASE_SETTING_1.to_a.permutation.map do |phase_setting_sequence|
      last_output = 0
      phase_setting_sequence.each do |phase_setting|
        amplifier = IntcodeComputer.new(@input.dup)
        amplifier.run([last_output, phase_setting])
        last_output = amplifier.output_values.first
      end
      last_output
    end.max
  end

  def calc_part_2
    PHASE_SETTING_2.to_a.permutation.map do |phase_setting_sequence|
      last_output = [0]

      amplifiers = phase_setting_sequence.map do |phase_setting|
        amplifier = IntcodeComputer.new(@input.dup)

        amplifier.run(last_output + [phase_setting])
        last_output = amplifier.output_values
        amplifier
      end

      while amplifiers.map(&:halted).include?(false) do
        amplifiers.each_with_index do |amplifier, i|
          amplifier.run(last_output)
          last_output = amplifier.output_values
        end
      end
      last_output.first
    end.max
  end
end