class Puzzle
  def initialize(input = nil)
    @input = input || File.readlines("input").map(&:strip)
  end

  CENTER = "COM"

  def prepare_orbits
    @orbits = {}
    @input.each do |input|
      center, satelite = input.split(")")
      @orbits[center] = (@orbits[center] || []) + [satelite]
    end

    self
  end

  def calc_part_1
    calculate_total_orbits(CENTER, 0, 0)
  end

  def calc_part_2(destination_1, destination_2)
    route_1 = find_route(CENTER, destination_1)
    route_2 = find_route(CENTER, destination_2)

    center_to_crossing = route_1 & route_2

    (route_1 - center_to_crossing).size + (route_2 - center_to_crossing).size
  end

  private

  def calculate_total_orbits(center, distance_from_center, total_orbits)
    satelites = @orbits[center]
    return total_orbits + distance_from_center if satelites.nil?

    total_orbits + distance_from_center + satelites.map do |satelite|
      calculate_total_orbits(satelite, distance_from_center+1, total_orbits)
    end.sum
  end

  def find_route(center, destination, route = [])
    satelites = @orbits[center]

    return nil if satelites.nil?
    return route+[center] if satelites.include?(destination)

    satelites.flat_map do |satelite|
      find_route(satelite, destination, route+[center])
    end.reject(&:nil?).reject(&:empty?)
  end
end
