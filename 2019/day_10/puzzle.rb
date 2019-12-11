class Puzzle
  def initialize(input = nil)
    @input = input || File.readlines("input").map(&:strip)
    @asteroids = build_asteroid_coords
  end

  def calc_part_1
    @asteroids.map do |asteroid|
      calculate_number_of_visible_asteroids(asteroid)
    end.max_by{ |a| a[:asteroids] }
  end

  def calc_part_2(station_x, station_y)
    angles = build_angle_groups_for_station(station_x, station_y)

    vaporized_asteroids = []
    loop do
      vaporized_asteroids += vaporize_360_degrees(angles)
      break if vaporized_asteroids.size == (@asteroids.size-1)
    end
    vaporized_asteroids
  end

  private

  def build_asteroid_coords
    @input.each_with_index.flat_map do |row, y|
      row.split("").each_with_index.map do |point, x|
        [x, y] if point == "#"
      end
    end.reject(&:nil?)
  end

  def calculate_number_of_visible_asteroids(station_coords)
    visible_asteroids = (@asteroids - [station_coords]).map do |x, y|
      calculate_angle(station_coords, [x, y])
    end.uniq.size

    {coords: station_coords, asteroids: visible_asteroids}
  end

  def calculate_angle(station_coords, asteroid_coords)
    station_x, station_y = station_coords
    x, y = asteroid_coords

    tangent = Math.atan2(y - station_y, x - station_x)
  end

  def build_angle_groups_for_station(station_x, station_y)
    (@asteroids - [[station_x, station_y]]).map do |x, y|
      angle = calculate_angle([station_x, station_y], [x, y]) + Math::PI / 2
      angle = angle < 0 ? angle + 2 * Math::PI : angle # laser start up first (y-axis)

      distance = Math.sqrt((station_x - x).abs ** 2 + (station_y - y).abs ** 2)

      [angle, distance, [x, y]]
    end.sort
       .group_by{ |angle, distance| angle }
       .to_a
       .sort
  end

  def vaporize_360_degrees(angles)
    angles.map do |angle, asteroids|
      if asteroids.is_a?(Array) && !asteroids.empty?
        asteroid_vaporized = asteroids.shift
        asteroid_vaporized.last
      end
    end.reject(&:nil?)
  end
end
