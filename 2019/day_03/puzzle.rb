class Puzzle
	def initialize(input = nil)
		@input = (input || File.readlines("input").map(&:strip)).map{|line| line.split(",")}
	end

	def calc_part_1
    wires = @input.map{ |wire| translate_into_coords(wire) }
    cross_points = find_cross_points(wires)
    calculate_manhattan_distance(cross_points).min
	end

	def calc_part_2
    wires = @input.map{ |wire| translate_into_coords(wire) }
    cross_points = find_cross_points(wires)
    calculate_steps_to_nearest_intersection(cross_points).min
	end

  private

  def translate_into_coords(wire)
    pos_x = 0
    pos_y = 0
    coords = []
    steps = 0

    wire.each do |fragment|
      direction, number = [fragment[0], fragment[1..-1].to_i]
      pos_x, pos_y, new_coords, steps = translate_fragment(direction, number, pos_x, pos_y, steps)
      coords = coords + new_coords
    end

    coords
  end

  def translate_fragment(direction, number, pos_x, pos_y, steps)
    coords = (1..number).map{ |i| build_coord(pos_x, pos_y, direction, i, steps)}
    [coords.last[:coord][0], coords.last[:coord][1], coords, steps+number]
  end

  def build_coord(pos_x, pos_y, direction, i, steps)
    case direction
    when "U"
      {coord: [pos_x, pos_y+i], steps: steps+i}
    when "D"
      {coord: [pos_x, pos_y-i], steps: steps+i}
    when "R"
      {coord: [pos_x+i, pos_y], steps: steps+i}
    when "L"
      {coord: [pos_x-i, pos_y], steps: steps+i}
    end
  end

  def find_cross_points(wires)
    wire_1, wire_2 = wires
    cross_point_coords = wire_1.map{ |c| c[:coord]} & wire_2.map{ |c| c[:coord]}

    cp = cross_point_coords.map do |coord|
      wire_1_coord = wire_1.select{ |c| c[:coord] == coord }.min_by{ |c| c[:steps] }
      wire_2_coord = wire_2.select{ |c| c[:coord] == coord }.min_by{ |c| c[:steps] }

      {coord: coord, wire_1_steps: wire_1_coord[:steps], wire_2_steps: wire_2_coord[:steps]}
    end
  end

  def calculate_manhattan_distance(cross_points)
    cross_points.map{ |coord| coord[:coord][0].abs + coord[:coord][1].abs }
  end

  def calculate_steps_to_nearest_intersection(cross_points)
    cross_points.map{ |coord| coord[:wire_1_steps] + coord[:wire_2_steps] }
  end
end