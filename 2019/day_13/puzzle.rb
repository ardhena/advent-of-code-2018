require_relative '../intcode_computer/intcode_computer'

class Puzzle
  def initialize(input = nil)
    @input = input || File.readlines("input").map(&:strip).first.split(",").map(&:to_i)
  end

  def calc_part_1
    game = ArcadeCabinet.new(@input)
    game.initialize_grid

    game.number_of_block_tiles
  end

  def calc_part_2(visual_mode = false)
    game = ArcadeCabinet.new(@input)
    ai = ArcadeCabinetAI.new

    game.initialize_grid
    game.run_game(ai, visual_mode)

    game.current_score
  end
end

class ArcadeCabinet
  EMPTY_TILE = 0
  WALL_TILE = 1
  BLOCK_TILE = 2
  HORIZONTAL_PADDLE_TILE = 3
  BALL_TILE = 4

  attr_reader :grid, :prev_ball_location, :current_score

  def initialize(input)
    @input = input
  end

  def initialize_grid
    @program = IntcodeComputer.new(@input)
    @program.run
    @grid = translate_tiles_to_grid(@program.output_values)
  end

  def draw_grid
    max_x = @grid.keys.max_by{ |x, _y| x }[0]
    max_y = @grid.keys.max_by{ |_x, y| y }[1]

    puts `clear`
    puts "TOTAL SCORE: #{@current_score}"
    puts
    (0..max_y).each do |y|
      puts (0..max_x).map{ |x| print_tile(@grid[[x, y]]) }.join
    end
  end

  def run_game(ai, visual_mode = false)
    @input[0] = 2
    @program = IntcodeComputer.new(@input)
    @current_score = 0
    @prev_ball_location = find_location(ArcadeCabinet::BALL_TILE)

    loop do
      break if number_of_block_tiles == 0
      
      if visual_mode
        sleep(0.05) 
        draw_grid
      end

      joystick_input = ai.determine_joystick_move(self)
      @prev_ball_location = find_location(ArcadeCabinet::BALL_TILE)

      @program.run(joystick_input)
      translate_tiles_to_grid(@program.output_values, @grid)
      @current_score = @grid[[-1,0]]
    end
  end

  def find_location(tile_code)
    @grid.select{ |_, tc| tc == tile_code }.keys.first
  end

  def number_of_block_tiles
    @grid.select{ |coords, tile_code| tile_code == ArcadeCabinet::BLOCK_TILE }.size
  end

  private

  def translate_tiles_to_grid(tiles, grid = {})
    tiles.each_slice(3).to_a.each do |tile|
      x, y, tile_code = tile
      grid[[x, y]] = tile_code
    end
    grid
  end

  def print_tile(tile_code)
    return " " if tile_code == EMPTY_TILE
    return "#" if tile_code == WALL_TILE
    return "x" if tile_code == BLOCK_TILE
    return "-" if tile_code == HORIZONTAL_PADDLE_TILE
    return "O" if tile_code == BALL_TILE
  end
end

class ArcadeCabinetAI
  def determine_joystick_move(game)
    ball_coords = game.find_location(ArcadeCabinet::BALL_TILE)
    paddle_coords = game.find_location(ArcadeCabinet::HORIZONTAL_PADDLE_TILE)
    ball_direction = ball_coords[0] - game.prev_ball_location[0]

    return 1 if (ball_direction == 1 && paddle_coords[0] < ball_coords[0]) # right
    return -1 if (ball_direction == -1 && paddle_coords[0] > ball_coords[0]) #left
    0
  end
end
