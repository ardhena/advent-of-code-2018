class Puzzle
	def initialize(input = nil)
		@input = input || File.readlines("input").map(&:strip).first.split(",").map(&:to_i)
	end

	ADD_CODE = 1
	MULTIPLY_CODE = 2
	HALT_CODE = 99

	def adjust_input(noun, verb)
		@input[1] = noun
		@input[2] = verb
		self
	end

	def calc_part_1
		handle_opcode(0)
	end

	class << self
		def calc_part_2(expected_value)
			output = Puzzle.new.adjust_input(self.generate_value(), self.generate_value()).calc_part_1()
			return 100 * output[1] + output[2] if expected_value == output[0]
			self.calc_part_2(expected_value)
		end

		def generate_value
			(0..99).to_a.sample
		end
	end

	private

	def handle_opcode(instruction_pointer)
		opcode = @input[instruction_pointer]
		return @input if opcode == HALT_CODE

		handle_addition(instruction_pointer) if opcode == ADD_CODE
		handle_multiplication(instruction_pointer) if opcode == MULTIPLY_CODE
		handle_opcode(instruction_pointer+4)
	end

	def handle_addition(instruction_pointer)
		source_1, source_2, target = @input[(instruction_pointer+1)..(instruction_pointer+3)]
		@input[target] = @input[source_1] + @input[source_2]
	end

	def handle_multiplication(instruction_pointer)
		source_1, source_2, target = @input[(instruction_pointer+1)..(instruction_pointer+3)]
		@input[target] = @input[source_1] * @input[source_2]
	end
end