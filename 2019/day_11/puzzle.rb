require_relative '../intcode_computer/intcode_computer'

BLACK_PANEL = 0
WHITE_PANEL = 1

class Puzzle

  def initialize(input = nil)
    @input = input || File.readlines("input").map(&:strip).first.split(",").map(&:to_i)
  end

  def calc_part_1
    panels = run_robot(BLACK_PANEL)
    panels.keys.size
  end

  def calc_part_2
    panels = run_robot(WHITE_PANEL)

    start_x, end_y = [panels.min_by{ |panel| panel[0][0] }[0][0], panels.max_by{ |panel| panel[0][1] }[0][1]]
    end_x, start_y = [panels.max_by{ |panel| panel[0][0] }[0][0], panels.min_by{ |panel| panel[0][1] }[0][1]]

    hull = (start_y..end_y).to_a.reverse.map do |row|
      (start_x..end_x).to_a.map do |panel|
        print_panel(panels[[panel, row]] || BLACK_PANEL)
      end.join("")
    end

    hull.each{ |row| puts row }

    hull
  end

  private

  def run_robot(first_panel_color)
    robot = Robot.new(@input)
    panels = {}
    robot.ask_camera_for_panel_color(panels, first_panel_color)

    loop do
      robot.process_panel
      panels[robot.coords] = robot.new_panel_color

      break if robot.finished?
      robot.turn_and_go
      robot.ask_camera_for_panel_color(panels)
    end

    panels
  end

  def print_panel(color)
    return "." if color == WHITE_PANEL
    return "x" if color == BLACK_PANEL
  end
end

class Robot
  TURN_LEFT_90_DEGREES = 0
  TURN_RIGTH_90_DEGREES = 1

  DIRECTIONS = {
    up: {TURN_LEFT_90_DEGREES => :left, TURN_RIGTH_90_DEGREES => :right},
    right: {TURN_LEFT_90_DEGREES => :up, TURN_RIGTH_90_DEGREES => :down},
    down: {TURN_LEFT_90_DEGREES => :right, TURN_RIGTH_90_DEGREES => :left},
    left: {TURN_LEFT_90_DEGREES => :down, TURN_RIGTH_90_DEGREES => :up}
  }

  MOVE = {
    x: {up: 0, right: 1, down: 0, left: -1},
    y: {up: 1, right: 0, down: -1, left: 0}
  }

  def initialize(input)
    @program = IntcodeComputer.new(input)
    @coords = [0,0]
    @direction = :up
  end

  def ask_camera_for_panel_color(panels, panel_color = nil)
    if panel_color.nil?
      @current_panel_color = panels[@coords] || BLACK_PANEL
    else
      @current_panel_color = panel_color
    end
  end

  def process_panel
    @program.run_until_outputs(@current_panel_color, 2)
    @new_panel_color, @turn_direction = @program.output_values
  end

  def turn_and_go
    @direction = DIRECTIONS[@direction][@turn_direction]
    @coords = [@coords[0] + MOVE[:x][@direction], @coords[1] + MOVE[:y][@direction]]
  end

  def finished?
    @program.halted
  end

  attr_reader :coords, :new_panel_color
end