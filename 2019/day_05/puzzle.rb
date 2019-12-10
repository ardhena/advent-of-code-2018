class Puzzle
  def initialize(input = nil)
    @input = input || File.readlines("input").map(&:strip).first.split(",").map(&:to_i)
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

  def calc_part_1(input_value = 1)
    @input_value = input_value
    @output_values = []

    handle_opcode(0)

    @output_values
  end

  private

  def handle_opcode(instruction_pointer)
    opcode_value = @input[instruction_pointer]
    return @input if opcode_value == HALT_CODE

    opcode = opcode_value % 100
    args_mode = [
      (opcode_value % 1000 / 100) || 0,
      (opcode_value % 10000 / 1000) || 0,
      (opcode_value % 100000 / 10000) || 0,
    ]

    new_instruction_pointer = 
      case opcode
      when ADD_CODE
        handle_addition(instruction_pointer, args_mode)
      when MULTIPLY_CODE
        handle_multiplication(instruction_pointer, args_mode)
      when INPUT_CODE
        handle_input(instruction_pointer, args_mode)
      when OUTPUT_CODE
        handle_output(instruction_pointer, args_mode)
      when JUMP_IF_TRUE_CODE
        handle_jump_if_true(instruction_pointer, args_mode)
      when JUMP_IF_FALSE_CODE
        handle_jump_if_false(instruction_pointer, args_mode)
      when LESS_THAN_CODE
        handle_less_than(instruction_pointer, args_mode)
      when EQUALS_CODE
        handle_equals(instruction_pointer, args_mode)
      end
      
    handle_opcode(new_instruction_pointer)
  end

  def handle_addition(instruction_pointer, args_mode)
    param_1 = fetch_value(instruction_pointer+1, args_mode[0])
    param_2 = fetch_value(instruction_pointer+2, args_mode[1])
    target = @input[instruction_pointer+3]

    @input[target] = param_1 + param_2

    instruction_pointer+4
  end

  def handle_multiplication(instruction_pointer, args_mode)
    param_1 = fetch_value(instruction_pointer+1, args_mode[0])
    param_2 = fetch_value(instruction_pointer+2, args_mode[1])
    target = @input[instruction_pointer+3]

    @input[target] = param_1 * param_2

    instruction_pointer+4
  end

  def handle_input(instruction_pointer, _args_mode)
    target =  @input[instruction_pointer+1]
    @input[target] = @input_value

    instruction_pointer+2
  end

  def handle_output(instruction_pointer, args_mode)
    target = fetch_value(instruction_pointer+1, args_mode[0])
    @output_values << target

    instruction_pointer+2
  end

  def handle_jump_if_true(instruction_pointer, args_mode)
    param_1 = fetch_value(instruction_pointer+1, args_mode[0])

    return fetch_value(instruction_pointer+2, args_mode[1]) if param_1 != 0
    instruction_pointer+3
  end

  def handle_jump_if_false(instruction_pointer, args_mode)
    param_1 = fetch_value(instruction_pointer+1, args_mode[0])

    return fetch_value(instruction_pointer+2, args_mode[1]) if param_1 == 0
    instruction_pointer+3
  end

  def handle_less_than(instruction_pointer, args_mode)
    param_1 = fetch_value(instruction_pointer+1, args_mode[0])
    param_2 = fetch_value(instruction_pointer+2, args_mode[1])
    target =  @input[instruction_pointer+3]

    @input[target] = param_1 < param_2 ? 1 : 0

    instruction_pointer+4
  end

  def handle_equals(instruction_pointer, args_mode)
    param_1 = fetch_value(instruction_pointer+1, args_mode[0])
    param_2 = fetch_value(instruction_pointer+2, args_mode[1])
    target =  @input[instruction_pointer+3]

    @input[target] = param_1 == param_2 ? 1 : 0

    instruction_pointer+4
  end

  def fetch_value(instruction_pointer, mode)
    return @input[@input[instruction_pointer]] if mode == POSITION_MODE
    return @input[instruction_pointer] if mode == IMMEDIATE_MODE
  end
end