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
  HALT_CODE = 99

  POSITION_MODE = 0
  IMMEDIATE_MODE = 1

  def initialize(program)
    @program = program
    @halted = false
    @instruction_pointer = 0
  end

  def run(input_value = nil)
    @input_value = input_value
    @output_values = []

    handle_opcode
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
      end
      
    handle_opcode
  rescue InputMissingError
    :pause
  end

  def handle_halt
    @halted = true
    @program
  end

  def handle_addition(args_mode)
    param_1 = fetch_value(@instruction_pointer+1, args_mode[0])
    param_2 = fetch_value(@instruction_pointer+2, args_mode[1])
    target = @program[@instruction_pointer+3]

    @program[target] = param_1 + param_2

    @instruction_pointer+4
  end

  def handle_multiplication(args_mode)
    param_1 = fetch_value(@instruction_pointer+1, args_mode[0])
    param_2 = fetch_value(@instruction_pointer+2, args_mode[1])
    target = @program[@instruction_pointer+3]

    @program[target] = param_1 * param_2

    @instruction_pointer+4
  end

  def handle_input(_args_mode)
    target =  @program[@instruction_pointer+1]
    @program[target] = 
      if @input_value.is_a?(Array) && !@input_value.empty?
        @input_value.pop
      elsif @input_value.is_a?(Array) && @input_value.empty?
        raise InputMissingError
      else
        @input_value
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
    target =  @program[@instruction_pointer+3]

    @program[target] = param_1 < param_2 ? 1 : 0

    @instruction_pointer+4
  end

  def handle_equals(args_mode)
    param_1 = fetch_value(@instruction_pointer+1, args_mode[0])
    param_2 = fetch_value(@instruction_pointer+2, args_mode[1])
    target =  @program[@instruction_pointer+3]

    @program[target] = param_1 == param_2 ? 1 : 0

    @instruction_pointer+4
  end

  def fetch_value(instruction_pointer, mode)
    return @program[@program[instruction_pointer]] if mode == POSITION_MODE
    return @program[instruction_pointer] if mode == IMMEDIATE_MODE
  end
end