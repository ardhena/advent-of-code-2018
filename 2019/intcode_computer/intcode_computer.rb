class IntcodeComputer
  class InputMissingError < RuntimeError
  end

  ADD_CODE = 1
  MULTIPLY_CODE = 2
  INPUT_CODE = 3
  OUTPUT_CODE = 4
  JUMP_IF_TRUE_CODE = 5
  JUMP_IF_FALSE_CODE = 6
  LESS_THAN_CODE = 7
  EQUALS_CODE = 8
  ADJUST_RELATIVE_BASE_CODE = 9
  HALT_CODE = 99

  POSITION_MODE = 0
  IMMEDIATE_MODE = 1
  RELATIVE_MODE = 2

  DEFAULT_VALUE = 0

  def initialize(program)
    @program = program
    @halted = false
    @instruction_pointer = 0
    @relative_base = 0
  end

  def run(input_value = [])
    @input_value = input_value.is_a?(Array) ? input_value : [input_value]
    @output_values = []

    loop do
      exit_code = handle_opcode
      break if exit_code == :halt
      break if exit_code == :pause
    end

    @program
  end

  def run_until_outputs(input_value, output_size)
    @input_value = input_value.is_a?(Array) ? input_value : [input_value]
    @output_values = []

    loop do
      exit_code = handle_opcode
      break if exit_code == :halt
      break if exit_code == :pause
      break if @output_values.size >= output_size
    end

    @program    
  end

  attr_reader :halted, :output_values

  private

  def handle_opcode
    opcode_value = @program[@instruction_pointer]
    return handle_halt if opcode_value == HALT_CODE

    opcode = opcode_value % 100
    args_mode = [
      (opcode_value % 1000 / 100) || 0,
      (opcode_value % 10000 / 1000) || 0,
      (opcode_value % 100000 / 10000) || 0,
    ]

    @instruction_pointer = 
      case opcode
      when ADD_CODE
        handle_addition(args_mode)
      when MULTIPLY_CODE
        handle_multiplication(args_mode)
      when INPUT_CODE
        handle_input(args_mode)
      when OUTPUT_CODE
        handle_output(args_mode)
      when JUMP_IF_TRUE_CODE
        handle_jump_if_true(args_mode)
      when JUMP_IF_FALSE_CODE
        handle_jump_if_false(args_mode)
      when LESS_THAN_CODE
        handle_less_than(args_mode)
      when EQUALS_CODE
        handle_equals(args_mode)
      when ADJUST_RELATIVE_BASE_CODE
        handle_adjust_relative_base(args_mode)
      end
  rescue InputMissingError
    :pause
  end

  def handle_halt
    @halted = true
    :halt
  end

  def handle_addition(args_mode)
    param_1 = fetch_value(@instruction_pointer+1, args_mode[0])
    param_2 = fetch_value(@instruction_pointer+2, args_mode[1])
    target = fetch_address(@instruction_pointer+3, args_mode[2])

    @program[target] = param_1 + param_2

    @instruction_pointer+4
  end

  def handle_multiplication(args_mode)
    param_1 = fetch_value(@instruction_pointer+1, args_mode[0])
    param_2 = fetch_value(@instruction_pointer+2, args_mode[1])
    target = fetch_address(@instruction_pointer+3, args_mode[2])

    @program[target] = param_1 * param_2

    @instruction_pointer+4
  end

  def handle_input(args_mode)
    target = fetch_address(@instruction_pointer+1, args_mode[0])
    @program[target] = 
      if @input_value.is_a?(Array) && !@input_value.empty?
        @input_value.pop
      elsif (@input_value.is_a?(Array) && @input_value.empty?) || @input_value.nil?
        raise InputMissingError
      else
        val = @input_value
        @input_value = nil
        val
      end

    @instruction_pointer+2
  end

  def handle_output(args_mode)
    target = fetch_value(@instruction_pointer+1, args_mode[0])
    @output_values << target

    @instruction_pointer+2
  end

  def handle_jump_if_true(args_mode)
    param_1 = fetch_value(@instruction_pointer+1, args_mode[0])

    return fetch_value(@instruction_pointer+2, args_mode[1]) if param_1 != 0
    @instruction_pointer+3
  end

  def handle_jump_if_false(args_mode)
    param_1 = fetch_value(@instruction_pointer+1, args_mode[0])

    return fetch_value(@instruction_pointer+2, args_mode[1]) if param_1 == 0
    @instruction_pointer+3
  end

  def handle_less_than(args_mode)
    param_1 = fetch_value(@instruction_pointer+1, args_mode[0])
    param_2 = fetch_value(@instruction_pointer+2, args_mode[1])
    target = fetch_address(@instruction_pointer+3, args_mode[2])

    @program[target] = param_1 < param_2 ? 1 : 0

    @instruction_pointer+4
  end

  def handle_equals(args_mode)
    param_1 = fetch_value(@instruction_pointer+1, args_mode[0])
    param_2 = fetch_value(@instruction_pointer+2, args_mode[1])
    target = fetch_address(@instruction_pointer+3, args_mode[2])

    @program[target] = param_1 == param_2 ? 1 : 0

    @instruction_pointer+4
  end

  def handle_adjust_relative_base(args_mode)
    param_1 = fetch_value(@instruction_pointer+1, args_mode[0])

    @relative_base += param_1
    @instruction_pointer+2
  end

  def fetch_value(instruction_pointer, mode)
    return @program[@program[instruction_pointer] || DEFAULT_VALUE] || DEFAULT_VALUE if mode == POSITION_MODE
    return @program[instruction_pointer] || DEFAULT_VALUE if mode == IMMEDIATE_MODE
    return @program[@relative_base + (@program[instruction_pointer] || DEFAULT_VALUE)] if mode == RELATIVE_MODE
  end

  def fetch_address(instruction_pointer, mode)
    return @relative_base + (@program[instruction_pointer] || DEFAULT_VALUE) if mode == RELATIVE_MODE
    @program[instruction_pointer] || DEFAULT_VALUE
  end
end